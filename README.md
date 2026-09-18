# Oikotaan — website

A static site built with [Astro](https://astro.build) and [Tailwind CSS](https://tailwindcss.com),
hosted free on Netlify. There is no server and no database: pages are generated
at build time from Markdown files, and anything that needs to accept money or
store submissions is handed to a service that does it for free.

```
GitHub (source of truth)
   │  merge to main
   ▼
Netlify  ──► www.oikotaan.org
   │
   ├── Netlify Forms  → general enquiries (~100/month on the free tier)
   ├── Zeffy          → donations, tickets, membership (no fees to us)
   └── Google Calendar→ rehearsals, classes, committee meetings
```

## Running it locally

New contributors can follow the step-by-step [Teen Contributor Manual](TEEN_MANUAL.md),
which covers computer setup, VS Code, Git branches, local previews, checks, and
pull requests.

You need Node 22. The version is pinned in `.nvmrc`, so `nvm use` picks it up.

```bash
./run.sh start
```

That installs dependencies if they are stale, takes port 4321, starts the dev
server in the background and opens the site. Edits reload as you save.

| Command            | What it does                                                             |
| ------------------ | ------------------------------------------------------------------------ |
| `./run.sh start`   | Dev server in the background, browser opened                             |
| `./run.sh stop`    | Stops it, and waits for the port to actually come free                   |
| `./run.sh restart` |                                                                          |
| `./run.sh status`  | Pid, port, and a request against each route so you see what is answering |
| `./run.sh logs`    | Follows the dev server log                                               |
| `./run.sh admin`   | Opens the content editor at /admin                                       |
| `./run.sh build`   | Type-checks and builds into `dist/`. This is what Netlify runs.          |
| `./run.sh preview` | Builds, then serves `dist/` on :4322 the way Netlify will                |
| `./run.sh check`   | What CI runs, plus formatting. Run it before opening a pull request.     |
| `./run.sh clean`   | Drops `dist/`, `.astro/` and the Vite cache                              |

The underlying npm scripts (`npm run dev`, `build`, `preview`, `format`) still
work if you prefer them. `run.sh` exists because the dev server in the
background, the port taken rather than quietly moved, and one command that tells
you whether CI will pass are all things you otherwise rediscover by hand.

**No install, no laptop setup:** open the repo on GitHub, press `.`, or use the
green **Code** button → **Codespaces**. `.devcontainer/devcontainer.json` installs
everything and starts the dev server for you. Check how Codespaces minutes are
billed for the organisation before putting a whole class on it.

## Where things live

```
src/
  site.config.ts        Org name, email, Zeffy links, calendar ID. Edit here, not in templates.
  content.config.ts     The schema every event file is checked against at build time.
  content/events/       One Markdown file per event. Adding a file adds a page.
  components/           Reusable pieces: Header, Footer, EventCard, ContactForm.
  layouts/BaseLayout    The shell every page sits inside: <head>, fonts, header, footer.
  pages/                One file per route. index.astro is the homepage.
  pages/admin/          The content editor, served at /admin
  styles/global.css     Colours and fonts, defined once as Tailwind tokens.
  lib/dates.ts          Date formatting, including the UTC handling events depend on.
run.sh                  Start, stop, check and build the site locally.
public/
  admin/config.yml      What the editor shows in its form. Read at runtime, not build time.
  images/uploads/       Images. Keep every file under 200KB.
```

## Adding an event

Two ways, and they produce the same commit.

**In the browser:** go to `/admin`, sign in with GitHub, fill in the form.

**In code:** create `src/content/events/your-event.md`, copy the frontmatter from
an existing file, and change it. The filename becomes the URL.

If the build fails with a message about the events collection, the frontmatter
does not match `src/content.config.ts`. That check is deliberate: it catches a
missing date on your laptop rather than on the live site.

## One-time setup

Everything below is done once, by an adult, before the kids start.

### 1. Own it as the organisation, not as a person

The usual way a volunteer-built nonprofit site dies is that the domain, the repo
and the hosting all sit in one student's personal account and nobody can reach
them two years later.

- [ ] GitHub **Organization** account with at least two adults as owners
- [ ] Netlify **team**, same two adults
- [ ] Domain registered to the organisation, using an organisation email address
- [ ] Zeffy account in the organisation's legal name

### 2. Netlify

1. Netlify → **Add new site** → **Import an existing project** → pick this repo.
2. Build command `npm run build`, publish directory `dist`. `netlify.toml`
   already says so, so the defaults should be correct.
3. Add the custom domain. Netlify issues the HTTPS certificate itself.
4. **Forms** → check that the `contact` form appears after the first deploy, and
   add an email notification so submissions reach a real inbox.

Every pull request now gets its own live preview URL. That is the best part of
this setup: a change can be looked at on a phone before anyone merges it.

### 3. Wiring up the content editor

Sveltia CMS talks to GitHub, and GitHub requires an OAuth application. There is
no shared public one, on purpose, so there is a ten-minute setup:

1. Deploy [`sveltia-cms-auth`](https://github.com/sveltia/sveltia-cms-auth) to
   Cloudflare Workers, free tier, following its README.
2. Create a GitHub OAuth app pointing at that worker.
3. Put the worker URL in `public/admin/config.yml` as `base_url`, and set `repo`
   to your organisation and repository.

If deploying a worker is more than you want to take on, **[Pages CMS](https://pagescms.org)**
does the same job with hosted authentication and a `.pages.yml` file instead.
Same idea, no worker, one more vendor in the stack.

### 4. Zeffy

Zeffy charges nothing: no platform fee, and it absorbs the card processing fee,
so a $100 donation arrives as $100. It funds itself by showing the donor an
optional contribution at checkout, pre-filled, which they can set to zero.

Say so on the donate page. Donors who do not notice the default and then see a
larger charge will email the treasurer, and it is better that they heard it from
us first.

Requires 501(c)(3) verification. Paste the hosted page URLs into
`src/site.config.ts` once it clears.

### 5. Google

- **Google for Nonprofits** gives free Workspace: `@yourorg.org` email, an
  organisation-owned Calendar, and Drive. Needs TechSoup validation.
- Make the calendar public (Calendar settings → **Make available to public**) or
  the embed on the events page renders an empty box with no error.
- Put its calendar ID in `src/site.config.ts`.
- Use **Google Forms** for event registration. Netlify Forms caps out around 100
  submissions a month on the free tier, and one popular event clears that.

## Photographs

Do not commit large images. Git keeps every version of every file forever, so a
single 4MB phone photo makes the repository slower to clone for every person on
the team from that day on.

- Banner images: resize to 1600px wide, save under 200KB, put in `public/images/uploads/`.
- Full galleries: a shared **Google Photos** album, linked from the event page.
- Publish photographs of children only with a parent's consent. The footer
  carries a takedown contact; keep it working.

## What this costs

|                 |           |
| --------------- | --------- |
| Domain          | ~$12/year |
| Everything else | $0        |
