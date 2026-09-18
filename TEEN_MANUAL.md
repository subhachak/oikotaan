# Oikotaan Teen Contributor Manual

Welcome! This guide explains how to work on the Oikotaan website from your own
computer. You do not need to be an expert. You need a text editor, a few tools,
and a habit of previewing your work before asking for it to be published.

## The big picture

The website is made from files in this repository:

- **Astro** turns the files into web pages.
- **Markdown** files contain event information.
- **CSS** controls colours, fonts, spacing, and layout.
- **Git** records changes on your computer.
- **GitHub** stores the project and lets people review changes.
- **Netlify** builds pull requests and gives each one a private preview URL.

The live website comes from `main`. You should never edit `main` directly. Make
a branch, make one focused change, open a pull request, and wait for review.

## What you can work on

Good beginner tasks include:

- fixing a typo or changing wording;
- adding or updating an event;
- adding an event image;
- changing a homepage sentence;
- making a small spacing or layout improvement.

Ask an adult or technical maintainer before changing:

- `package.json`, Node versions, or installed packages;
- `astro.config.mjs`, `netlify.toml`, or deployment settings;
- GitHub permissions, Netlify, the domain, or CMS authentication;
- routing, the content schema, or anything involving privacy or security.

## Option A: use GitHub Codespaces

Codespaces is the easiest setup because the tools are already installed.

1. Open the repository on GitHub.
2. Select **Code** > **Codespaces** > **Create codespace on main**.
3. Wait for the browser version of VS Code to finish loading.
4. Open the built-in terminal with **Terminal > New Terminal**.
5. Continue at [Start the website](#start-the-website).

Codespaces can use organisation resources, so check with an adult before a whole
class creates one. Close the codespace when you are finished.

## Option B: set up your own computer

### Install the tools

Install these tools from their official websites or your computer's package
manager:

1. **VS Code**: the editor where you will open and change files.
2. **Git**: the tool that records and shares your changes.
3. **Node.js 22**: the program that runs Astro. The required version is written
   in `.nvmrc`.

On macOS or Linux, `nvm` is a convenient way to install and select Node:

```bash
nvm install 22
nvm use 22
```

On Windows, an adult can help install Node 22 using the Windows installer or
`nvm-windows`. After installing, check that the tools work:

```bash
node --version
git --version
```

The Node version should start with `v22`. If it does not, stop and fix the Node
version before continuing.

### Download the project

Ask the project maintainer for repository access if GitHub says you do not have
permission. In a terminal, run:

```bash
git clone https://github.com/subhachak/oikotaan.git
cd oikotaan
npm install
code .
```

If `code .` does not work, open VS Code normally and choose **File > Open
Folder**, then select the `oikotaan` folder.

You only need to clone the project once. The next time, open the existing folder
and start at [Get ready for a new change](#get-ready-for-a-new-change).

## Start the website

From the project folder, run:

```bash
./run.sh start
```

Open <http://localhost:4321> if the browser does not open automatically. Keep
the terminal running while you work. When you save a file, the browser updates.

Useful commands:

| Command            | What it does                                            |
| ------------------ | ------------------------------------------------------- |
| `./run.sh start`   | Starts the editable development site on port 4321       |
| `./run.sh stop`    | Stops the development site                              |
| `./run.sh restart` | Stops and starts it again                               |
| `./run.sh status`  | Checks whether the site and important routes respond    |
| `./run.sh logs`    | Shows the development server log                        |
| `./run.sh admin`   | Opens the local content editor at `/admin`              |
| `./run.sh preview` | Builds and serves the production-like site on port 4322 |
| `./run.sh check`   | Runs formatting, type checks, and the build before a PR |

When you are done, stop the site with:

```bash
./run.sh stop
```

## Where to edit

| Task                                           | File or folder                                  |
| ---------------------------------------------- | ----------------------------------------------- |
| Add or edit an event                           | `src/content/events/`                           |
| Change homepage text or structure              | `src/pages/index.astro`                         |
| Change the header or footer everywhere         | `src/components/Header.astro` or `Footer.astro` |
| Change colours and fonts                       | `src/styles/global.css`                         |
| Change organisation details and external links | `src/site.config.ts`                            |
| Change the page shell and `<head>`             | `src/layouts/BaseLayout.astro`                  |

For a normal event update, the safest choice is an existing Markdown file in
`src/content/events/`. The filename becomes part of the event URL.

### Editing an event

An event file starts with frontmatter between the two `---` lines. Copy an
existing event and change its values carefully:

```md
---
title: "Community Picnic"
date: 2026-06-14
time: "12:00 PM onwards"
venue: "Community Park"
address: "1 Main Street, Edison, NJ"
summary: "A relaxed afternoon for the whole community."
image: "/images/uploads/picnic.jpg"
imageAlt: "Families sharing food at picnic tables"
featured: false
draft: false
---

Write the event details here.
```

Keep `draft: true` while an event is unfinished. It will not appear as a normal
published event. Change it to `false` only when the information is ready and an
adult has approved it.

Images belong in `public/images/uploads/`. Keep each image under **200 KB**.
Resize phone photos before adding them. Every image needs useful `imageAlt`
text; use `alt: ""` only for decoration that communicates no information.

## Get ready for a new change

Before starting, make sure your copy is up to date:

```bash
git checkout main
git pull origin main
git checkout -b update-event-details
```

Use a branch name that describes the task, such as:

- `add-poila-boishakh-event`
- `fix-homepage-typo`
- `improve-mobile-event-cards`

Do not use names like `stuff` or `fix`. One branch should contain one focused
change. If you have two unrelated ideas, make two branches and two pull
requests.

## Make and inspect your change

1. Open the relevant file in VS Code.
2. Change the smallest amount of code or content needed.
3. Save the file and look at the local website.
4. Check the page at a narrow browser width as well as a desktop width.
5. Check links, spelling, dates, images, and headings.
6. Review what Git sees:

```bash
git status
git diff
```

The diff should contain only the change you intended. If it includes something
you do not recognise, stop and ask for help.

## Test before sharing

First use the fast local browser preview. Then run the same kind of checks that
CI and Netlify will run:

```bash
./run.sh check
```

This checks formatting, validates the content and TypeScript, and builds the
site. A successful check ends with `check passed.`

For an extra check of the built version:

```bash
./run.sh preview
```

Open <http://localhost:4322>. Press `Ctrl-C` in that terminal to stop this
preview server.

If a check fails, read the last part of the error. It often names the file and
the exact problem. Fix the cause and run the same command again. Do not hide a
failure or remove a validation rule just to make the command green.

## Commit and push

When the change looks correct and checks pass:

```bash
git add src/content/events/your-event.md
git status
git commit -m "Add community picnic event"
git push -u origin update-event-details
```

Replace the path, commit message, and branch name with your actual change. For
several deliberately changed files, you can use `git add .`, but inspect
`git status` first. A commit message should say what changed. Avoid messages
like `update`, `changes`, or `fixes`.

## Open and finish the pull request

1. Open the repository on GitHub. Click **Compare & pull request**.
2. Explain what you changed and why.
3. Mention how you tested it, for example: `./run.sh check` and a phone-sized
   browser check.
4. Ask the appropriate adult or maintainer for review.
5. Wait for the Netlify **deploy preview** check. Open its URL and test the
   actual preview on your computer and phone if possible.
6. Respond to review comments by editing the same branch, then run checks,
   commit, and push again. The pull request updates automatically.
7. A maintainer merges the pull request after review. Do not merge your own
   change unless the team has explicitly given you that responsibility.

After merging, clean up your local copy:

```bash
git checkout main
git pull origin main
git branch -d update-event-details
```

## Common problems

**`npm` or `node` is not recognised.** Node.js is not installed or is not on
your PATH. Install/select Node 22, then open a new terminal.

**The browser says the site cannot be reached.** Run `./run.sh status`. If the
server is stopped, run `./run.sh start`. If another process is using a port,
ask an adult before stopping it.

**The build says the event collection is invalid.** Check the frontmatter in the
event file against another event. A date, quote, indentation, or field name is
probably wrong.

**Git says there is a merge conflict.** Do not panic or delete random files.
Open the marked file, choose the text that should remain, remove the conflict
markers, save, then run `git add`, `git commit`, and `git push`.

**GitHub rejects your push.** You may not have permission, or the branch name
may be wrong. Copy the full error and ask the maintainer; do not paste passwords
or tokens into chat.

**You changed or deleted the wrong thing.** Stop editing and ask for help. Git
usually has the old version, so more random changes will only make recovery
harder.

## Safety and privacy rules

- Never commit passwords, tokens, private keys, or personal data.
- Do not publish photographs of children without a parent's consent.
- Never push directly to `main`.
- Never commit an image over 200 KB.
- Do not add packages or change hosting settings without adult approval.
- Check the Netlify preview before anything is merged.
- Share the actual error message when asking for help, along with what you
  already tried.

That is the complete loop: **branch, change, preview, check, commit, push,
review, merge**.
