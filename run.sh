#!/usr/bin/env bash
# Runs the Oikotaan site locally: the Astro dev server (:4321), and a preview
# server for the real production build (:4322).
#
#   ./run.sh start            # start the dev server in the background, open Chrome
#   ./run.sh stop
#   ./run.sh restart
#   ./run.sh status           # ports, pids, and what is actually answering
#   ./run.sh logs
#   ./run.sh admin            # open the content editor at /admin
#   ./run.sh build            # type-check and build into dist/
#   ./run.sh preview          # build, then serve dist/ the way Netlify will
#   ./run.sh check            # what CI runs, plus formatting: run this before opening a PR
#   ./run.sh clean            # drop dist/, .astro/ and the Vite cache
#
# 4321 and 4322 avoid the ports the sibling projects on this machine claim
# (3000/3010/3020, 8000/8010/8020, 4000), whose launchers kill whatever holds
# them. Override with PORT / PREVIEW_PORT.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_DIR="$SCRIPT_DIR/.run"

PORT="${PORT:-4321}"
PREVIEW_PORT="${PREVIEW_PORT:-4322}"
APP_URL="http://localhost:$PORT"
PREVIEW_URL="http://localhost:$PREVIEW_PORT"

mkdir -p "$RUN_DIR"
DEV_LOG="$RUN_DIR/dev.log"; DEV_PID_FILE="$RUN_DIR/dev.pid"

# --- helpers ---------------------------------------------------------------

is_running() {
  local pid_file="$1"
  [[ -f "$pid_file" ]] && kill -0 "$(<"$pid_file")" 2>/dev/null
}

wait_for_http() {
  local url="$1" timeout="$2" waited=0
  while (( waited < timeout )); do
    curl -fs -o /dev/null "$url" && return 0
    sleep 1
    waited=$((waited + 1))
  done
  return 1
}

free_port() {
  local port="$1" pids
  pids="$(lsof -ti "tcp:$port" -sTCP:LISTEN 2>/dev/null || true)"
  if [[ -n "$pids" ]]; then
    echo "Port $port is already in use (pid(s) ${pids//$'\n'/, }) — stopping it to take over."
    kill $pids 2>/dev/null || true
    sleep 1
    pids="$(lsof -ti "tcp:$port" -sTCP:LISTEN 2>/dev/null || true)"
    [[ -n "$pids" ]] && kill -9 $pids 2>/dev/null || true
  fi
  return 0
}

kill_tree() {
  local pid="$1" child
  for child in $(pgrep -P "$pid" 2>/dev/null || true); do
    kill_tree "$child"
  done
  kill "$pid" 2>/dev/null || true
}

stop_pid_tree() {
  local pid_file="$1" name="$2"
  if is_running "$pid_file"; then
    local pid waited=0
    pid="$(<"$pid_file")"
    echo "Stopping $name (pid $pid)..."
    kill_tree "$pid"
    # npm run dev is a wrapper around the astro process, so killing the pid we
    # recorded leaves the real server holding the port for a moment. Without
    # this wait, `restart` finds the port still taken and kills it twice.
    while (( waited < 10 )) && kill -0 "$pid" 2>/dev/null; do
      sleep 0.5
      waited=$((waited + 1))
    done
    kill -9 "$pid" 2>/dev/null || true
  fi
  rm -f "$pid_file"
}

open_url() {
  local url="$1"
  open -a "Google Chrome" "$url" 2>/dev/null || open "$url" 2>/dev/null \
    || echo "Open this manually: $url"
}

# --- dependencies ----------------------------------------------------------

ensure_dependencies() {
  command -v node >/dev/null 2>&1 || { echo "node is required: see .nvmrc for the version" >&2; exit 1; }

  # The lockfile being newer than node_modules is the case that actually bites:
  # someone pulls a branch that added a dependency, npm says nothing, and the
  # build fails on an import that looks correct.
  if [[ ! -d "$SCRIPT_DIR/node_modules" || "$SCRIPT_DIR/package-lock.json" -nt "$SCRIPT_DIR/node_modules" ]]; then
    echo "installing dependencies..."
    (cd "$SCRIPT_DIR" && npm ci --silent)
  fi
}

# --- lifecycle -------------------------------------------------------------

do_start() {
  if is_running "$DEV_PID_FILE"; then
    echo "The dev server is already running (use ./run.sh restart)."
    exit 0
  fi

  ensure_dependencies
  # Astro quietly moves to the next free port when the one it was given is
  # taken. That is friendly until you are looking at a stale server from an
  # hour ago and wondering why your edit did nothing, so take the port instead.
  free_port "$PORT"

  echo "dev: starting on :$PORT (log: $DEV_LOG)"
  (
    cd "$SCRIPT_DIR"
    exec npm run dev -- --port "$PORT"
  ) > "$DEV_LOG" 2>&1 &
  echo $! > "$DEV_PID_FILE"

  if wait_for_http "$APP_URL" 45; then
    echo "dev: ready"
  else
    echo "dev: failed to start — check $DEV_LOG" >&2
    do_stop
    exit 1
  fi

  echo
  echo "  site    $APP_URL"
  echo "  events  $APP_URL/events/"
  echo "  editor  $APP_URL/admin/"
  echo
  open_url "$APP_URL"
  echo "Use ./run.sh stop to shut it down."
}

do_stop() {
  stop_pid_tree "$DEV_PID_FILE" "dev"
  echo "Oikotaan dev server stopped."
}

do_status() {
  if is_running "$DEV_PID_FILE"; then
    printf "%-7s running  pid %-8s %s\n" "dev" "$(<"$DEV_PID_FILE")" "$APP_URL"
  elif lsof -ti "tcp:$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
    printf "%-7s running  (not started by this script, port %s in use)\n" "dev" "$PORT"
  else
    printf "%-7s stopped\n" "dev"
  fi

  # A pid alone says the process exists, not that the site works. One request
  # per route is the difference between "it is up" and "it is serving".
  if curl -fs -o /dev/null "$APP_URL" 2>/dev/null; then
    echo
    local path code
    for path in / /events/ /events/durga-puja-2026/ /admin/ /admin/config.yml /404; do
      code="$(curl -s -o /dev/null -w '%{http_code}' "$APP_URL$path")"
      printf "  %-28s %s\n" "$path" "$code"
    done
    echo
    echo "  /404 answering 404 is correct; every other route should be 200."
  fi
}

do_logs() {
  [[ -f "$DEV_LOG" ]] || { echo "No log yet — start the server first." >&2; exit 1; }
  tail -f "$DEV_LOG"
}

do_admin() {
  if ! curl -fs -o /dev/null "$APP_URL" 2>/dev/null; then
    echo "The dev server is not running — starting it first."
    do_start
  fi
  echo "Opening the content editor at $APP_URL/admin/"
  echo "Pick 'Work with Local Repository' to edit without GitHub sign-in."
  open_url "$APP_URL/admin/"
}

# --- build -----------------------------------------------------------------

do_build() {
  ensure_dependencies
  (cd "$SCRIPT_DIR" && npm run build)
}

do_preview() {
  do_build
  free_port "$PREVIEW_PORT"
  echo
  echo "Serving the built site at $PREVIEW_URL — this is what Netlify will publish."
  echo "Press Ctrl-C to stop."
  open_url "$PREVIEW_URL"
  (cd "$SCRIPT_DIR" && exec npm run preview -- --port "$PREVIEW_PORT")
}

# What CI enforces, plus the formatting CI does not. Running it before opening a
# pull request turns a red check into a local failure you can fix in a minute.
do_check() {
  ensure_dependencies
  local failed=0

  echo "==> formatting"
  (cd "$SCRIPT_DIR" && npx prettier --check .) || { failed=1; echo "    fix with: npm run format"; }

  echo "==> types and build"
  (cd "$SCRIPT_DIR" && npm run build) || failed=1

  echo
  if (( failed )); then
    echo "check failed — CI will fail on this too."
    exit 1
  fi
  echo "check passed."
}

do_clean() {
  if is_running "$DEV_PID_FILE"; then
    echo "The dev server is running — stop it first (./run.sh stop) so it is not rebuilding into a folder being deleted." >&2
    exit 1
  fi
  rm -rf "$SCRIPT_DIR/dist" "$SCRIPT_DIR/.astro" "$SCRIPT_DIR/node_modules/.vite"
  echo "Build output, the content cache and the Vite cache are gone. The next build recreates them."
}

case "${1:-}" in
  start)   do_start ;;
  stop)    do_stop ;;
  restart) do_stop; do_start ;;
  status)  do_status ;;
  logs)    do_logs ;;
  admin)   do_admin ;;
  build)   do_build ;;
  preview) do_preview ;;
  check)   do_check ;;
  clean)   do_clean ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|logs|admin|build|preview|check|clean}"
    exit 1
    ;;
esac
