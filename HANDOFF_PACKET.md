# Oikotaan Handoff Packet

## Purpose

This guide is for new contributors, especially teens with little coding experience, so they understand:

- what a web app is,
- how this site is built,
- where the important files live,
- what they are allowed to change,
- what should be left to adults.

The goal is to make this site easy to maintain without needing advanced technical knowledge.

---

## 1) What is a web app?

A web app is a website that is built with code and runs in a browser. Most modern websites are made from a few key parts:

- Frontend: the visible pages and design
- Backend: the logic that powers the site behind the scenes
- Database: where information is stored
- Hosting: the place where the site is published online
- Deployment: the process of sending updates live

### This project is a static site

This project is not a complicated app with user accounts or a database. Instead, it is a static website built from:

- HTML-like Astro pages
- CSS via Tailwind
- Markdown content files
- GitHub for version control
- Netlify for hosting and deployment

That means the site is usually easier to maintain because most updates are content changes, not software changes.

---

## 2) The stack used here

This project uses:

- Astro — for pages and layout
- Tailwind CSS — for styling
- Markdown — for event content
- GitHub — for source control and collaboration
- Netlify — for hosting and previews
- Sveltia CMS — browser-based editing for content

### Why this stack is a good fit

This is a good stack for a small nonprofit site because it is:

- simple to understand,
- static and low-risk,
- easy to preview before publishing,
- easy to update with content instead of code,
- cheap to host.

It is not a good fit for a team that wants a highly custom application with login systems, complex databases, or custom user data.

---

## 3) How the code is structured

The project is organized into a few main areas.

### Project root

- package.json — lists project scripts and dependencies
- astro.config.mjs — Astro configuration
- run.sh — helper script for start, stop, build, preview, and checks
- .nvmrc — tells the project which Node version to use

### Source code

- src/pages/ — page routes such as the homepage and event pages
- src/layouts/ — shared page shell and layout structure
- src/components/ — reusable UI blocks such as headers, cards, and contact form
- src/content/ — content files such as event markdown pages
- src/content.config.ts — rules for event content validation
- src/site.config.ts — organization-wide settings, links, and site data
- src/lib/dates.ts — date logic and formatting helpers

### Static and admin assets

- public/ — uploaded images and admin config
- public/admin/config.yml — CMS form configuration
- public/images/uploads/ — where images are stored

### What matters most

The project is designed so that most people can make changes without touching the full app architecture.

---

## 4) How the site works in plain English

### Content-driven workflow

The events page is driven by Markdown files in src/content/events. Each file represents one event.

Each event file has frontmatter, which is metadata such as:

- title
- date
- time
- venue
- summary
- image
- featured flag
- draft flag

The project validates this content using src/content.config.ts. If something is missing or typed incorrectly, the build fails early and clearly.

This is a good pattern for beginners because it catches mistakes before they go live.

### Page rendering

Pages such as the homepage are built using Astro. They pull in event data and render the content into a layout. This means the website is assembled from templates and content, not from a database query at runtime.

### Browser-based editing

The site also includes a content editor under /admin. This is meant to make updates easy for people who are not comfortable editing code directly.

The real purpose of this setup is to let volunteers:

- add events,
- update text,
- fix simple content issues,
- avoid coding complexity.

---

## 5) What the teens should be told to do

### Safe tasks for contributors

These are good beginner tasks:

- add or edit an event
- update event text and summary
- change wording on the homepage
- add an image to an event
- fix a typo in a page
- adjust layout spacing and simple styling

### Things that require care

These should be handled by an adult or a trusted technical maintainer:

- GitHub permissions and repo ownership
- deployment settings
- domain and hosting setup
- CMS authentication setup
- changes to build config
- changes to Astro config or package dependencies
- anything involving Node version or install issues
- security and data privacy decisions

---

## 6) Recommended handoff checklist

### Adult-owned setup

- [ ] GitHub organization account is owned by the group, not a person
- [ ] Netlify team is owned by the group, not one individual
- [ ] Domain is registered to the organization
- [ ] Admin contact details and official email are in place
- [ ] GitHub and Netlify permissions are shared with trusted adults

### Website and CMS setup

- [ ] Netlify is connected to the GitHub repo
- [ ] Build command and publish directory are correct
- [ ] CMS auth is set up if using Sveltia CMS
- [ ] Production URL is confirmed and working
- [ ] Preview URLs are reviewed before merging changes

### Content workflow

- [ ] Event files are created in the correct folder
- [ ] Required fields are filled in before publishing
- [ ] Drafts are hidden from the site until ready
- [ ] Images are kept small and under recommended size limits
- [ ] Accessibility label text is added for images when needed

### Maintenance rules

- [ ] Never push directly to production without review
- [ ] Always check preview before publishing
- [ ] Keep content updates simple and text-based when possible
- [ ] Do not commit large image files to the repo
- [ ] Keep the site as static and low-complexity as possible

### Beginner safety rules

- [ ] Do not edit package.json without understanding the change
- [ ] Do not change build or deployment settings without approval
- [ ] Do not delete or rename core folders without checking references
- [ ] Do not introduce new packages without adult review
- [ ] Ask before changing layout, routing, or CMS config

---

## 7) Simple rule for who does what

### Teens can usually do

- content updates
- event posting
- image upload for events
- text changes on pages
- simple design tweaks
- minor fixes after review

### Adults should own

- hosting and domain
- GitHub admin access
- deployment and production safety
- code-level troubleshooting
- dependency updates and build issues
- security and permissions

This separation is important. It keeps the project safe while still empowering the team.

---

## 8) The big idea to teach

A website is not magic. It is a set of files, templates, and rules that get turned into pages for the browser.

In this project:

- content files create the events,
- templates arrange the page,
- styles control appearance,
- GitHub keeps history,
- Netlify publishes the final result.

Once they understand that, the whole system stops feeling scary.

---

## 9) Final advice

This project is a good handoff for teens because it is intentionally built around content, not complexity.

The key is not to give them the whole technical burden. The key is to give them:

- a small scope,
- clear file locations,
- safe editing rules,
- a preview-and-review process,
- adult ownership of the technical infrastructure.

If that structure is maintained, the site can be a strong beginner-friendly project that the whole team can help manage.

---

## 10) One-page summary

This site is a simple Astro + Tailwind website with GitHub + Netlify hosting and a browser-based CMS. Most updates are content-based and safe for beginners. Adults should own the infrastructure, while teens can handle content and simple front-end edits under supervision.

That is the right balance for a community organization.
