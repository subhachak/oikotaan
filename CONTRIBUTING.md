# How to work on this site

Written for someone who has done a bit of programming but has not worked on a
team project before. Nothing here is hard. It is mostly a sequence.

## The idea

Nobody edits the live website. You change a copy, someone looks at your change,
and then it goes live on its own. That sounds slower than just editing the site,
and it is, by about ninety seconds. In exchange, nothing you do can break the
site for real, and anything that does go wrong can be undone in one click.

## Setting up, once

Easiest route, nothing to install: open the repo on GitHub, click **Code** →
**Codespaces** → **Create codespace on main**. You get VS Code in a browser tab
with everything already working. Skip to "Making a change".

On your own laptop:

```bash
git clone https://github.com/subhachak/oikotaan.git
cd oikotaan
npm install
npm run dev
```

Open http://localhost:4321. Leave that terminal running: it rebuilds the page
every time you save a file.

## Making a change

**1. Start from the latest main, on a new branch.**

```bash
git checkout main
git pull
git checkout -b events-page-spacing
```

Name the branch after what you are doing. `fix-stuff` tells the next person
nothing.

Never commit to `main` directly. `main` is what the world sees.

**2. Change things.** Save. Look at the browser. Repeat.

**3. Check it builds before you push.**

```bash
npm run build
```

This catches typos that the dev server forgives. If it fails, read the last few
lines. The message is usually the actual answer, not a riddle.

**4. Commit and push.**

```bash
git add .
git commit -m "events page: cards no longer overlap on small phones"
git push -u origin events-page-spacing
```

Write the message so someone reading the history in a year knows what changed.
"update" and "fixes" are not messages.

**5. Open a pull request.** GitHub will offer a button. Say what you changed and
why.

Within a minute a bot comments with a **deploy preview** link. That is your
branch, live, on a real URL. Open it on your phone. Send it to whoever asked for
the change.

**6. Someone reviews it, then merges.** A few seconds later it is on the real
site.

## Things that will happen to you

**Merge conflict.** Two people changed the same lines. Git marks both versions
in the file with `<<<<<<<` and `>>>>>>>`. Delete the markers, keep the text that
should survive, save, commit. It is not a punishment, it is a question.

**You broke main.** You did not, but suppose you had. In Netlify, **Deploys** →
pick the last good one → **Publish deploy**. Site restored. Then fix the actual
problem without anyone watching.

**You deleted something important.** Git has it. Ask, do not panic, and do not
start deleting more things to tidy up.

## House rules

- One change per branch. A pull request that fixes the footer _and_ rewrites the
  homepage is hard to review and hard to undo.
- Never commit an image over 200KB. Resize it first. Git keeps every version of
  every file forever, so a big photo is permanent weight on everyone's clone.
- Colours and fonts belong in `src/styles/global.css`, as tokens. If you catch
  yourself writing `bg-[#c1272d]` in a page, use `bg-sindoor-600` instead.
- The organisation name, email and external links live in `src/site.config.ts`.
  Never type them into a template.
- Every `<img>` needs an `alt` describing the picture, for people using a screen
  reader. `alt=""` is correct for decoration only.
- If the build fails, do not work around the failure. It is telling you
  something true.

## Where to change what

| You want to                            | Open                                          |
| -------------------------------------- | --------------------------------------------- |
| Add or edit an event                   | `src/content/events/`                         |
| Change the menu                        | `src/site.config.ts`                          |
| Change the homepage                    | `src/pages/index.astro`                       |
| Change the header or footer everywhere | `src/components/Header.astro`, `Footer.astro` |
| Change colours or fonts                | `src/styles/global.css`                       |
| Change what every page has in `<head>` | `src/layouts/BaseLayout.astro`                |

## Asking for help

Open an issue, or leave a comment on your own pull request. Paste the actual
error text, not a description of it, and say what you already tried. Both make
the answer arrive faster.
