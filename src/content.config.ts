import { defineCollection, z } from "astro:content";
import { glob } from "astro/loaders";

/**
 * The events collection is the site's content database. Each Markdown file in
 * src/content/events/ is one event, and the schema below is checked at build
 * time: a missing date or a typo in a field name fails `npm run build` with a
 * readable message instead of shipping a broken page.
 *
 * This is also what the CMS at /admin reads to draw its form, so adding a field
 * here means adding it to public/admin/config.yml as well.
 */
const events = defineCollection({
  loader: glob({ pattern: "**/*.md", base: "./src/content/events" }),
  schema: z.object({
    title: z.string(),
    titleBengali: z.string().optional(),

    // Written as YYYY-MM-DD in the frontmatter. Zod turns it into a real Date,
    // which is what lets the listing page sort and split past from upcoming.
    date: z.coerce.date(),
    endDate: z.coerce.date().optional(),

    // Free text, because "6:00 PM onwards" and "Doors 5:30, program 6:00" are
    // both things the committee actually writes.
    time: z.string().optional(),

    venue: z.string(),
    address: z.string().optional(),

    summary: z.string().max(200),

    // Path under public/, e.g. /images/uploads/puja-2026.jpg
    // Keep these under 200KB. A 4MB phone photo makes the repo slow to clone
    // for every kid on the team, forever, because git keeps every version.
    image: z.string().optional(),
    imageAlt: z.string().optional(),

    // Zeffy ticket or registration page for this specific event.
    ticketUrl: z.string().url().optional(),

    // Pins the event to the top of the homepage.
    featured: z.boolean().default(false),

    // Set to true to keep a half-written event out of the build.
    draft: z.boolean().default(false),
  }),
});

/**
 * The homepage's editable content: everything a committee member should be
 * able to change without a pull request. Structural stuff — nav links, the
 * contact form's fields, org-wide settings like email and social links —
 * stays in src/site.config.ts, since that isn't page content, it's identity.
 *
 * src/content/home.yaml is a singleton: one file, glob-loaded the same way
 * events are, so its id is the filename ("home") and its data is the file's
 * content verbatim. That matters because the CMS (public/admin/config.yml)
 * reads and writes that file as a plain object matching the fields below —
 * an extra wrapping key here would round-trip fine in Astro but show up as
 * an empty form in the CMS, since it writes to the top level directly.
 */
const home = defineCollection({
  loader: glob({ pattern: "home.yaml", base: "./src/content" }),
  schema: z.object({
    hero: z.object({
      kicker: z.string(),
      heading: z.string(),
      description: z.string(),
      image: z.string(),
      imageAlt: z.string(),
    }),

    // One icon per program pillar, picked from a small fixed set drawn in
    // index.astro. Adding a new icon choice means adding it there too.
    programs: z.array(
      z.object({
        icon: z.enum(["flame", "book", "heart"]),
        title: z.string(),
        description: z.string(),
      }),
    ),

    gallery: z.array(
      z.object({
        image: z.string(),
        alt: z.string(),
      }),
    ),

    contact: z.object({
      heading: z.string(),
      body: z.string(),
    }),
  }),
});

export const collections = { events, home };
