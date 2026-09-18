/**
 * Every piece of organisation-specific text and every external link lives here.
 *
 * This file exists so that renaming the organisation, swapping the Zeffy page or
 * pointing at a different Google Calendar is a single edit instead of a hunt
 * through twenty templates. If you find yourself hardcoding an org name or a URL
 * inside a component, put it here instead.
 */
export const site = {
  name: "Oikotaan",
  shortName: "Oikotaan",
  nameBengali: "ঐকতান",
  tagline: "Celebrating Bengali culture, language and community in New Jersey.",
  description:
    "A volunteer-run 501(c)(3) nonprofit bringing Bengali families across New Jersey together through cultural programs, language classes and community service.",

  email: "hello@oikotaan.org",
  town: "6 Matthew Road, Hillsborough, NJ 08844",

  social: {
    facebook: "https://facebook.com/",
    instagram: "https://instagram.com/",
    youtube: "",
  },

  /**
   * Zeffy hosted pages. Zeffy passes on no platform or card fees, so a $100
   * donation arrives as $100; it funds itself with an optional contribution the
   * donor can set to zero at checkout. Paste the hosted page URLs from the Zeffy
   * dashboard here once the 501(c)(3) verification clears.
   */
  zeffy: {
    donateUrl: "https://www.zeffy.com/",
    membershipUrl: "https://www.zeffy.com/",
  },

  /**
   * Public Google Calendar ID, from Calendar settings -> Integrate calendar.
   * The calendar must be set to "Make available to public" or the embed renders
   * an empty box with no error.
   */
  googleCalendarId: "en.usa#holiday@group.v.calendar.google.com",
  timeZone: "America/New_York",
} as const;

export const nav = [
  { label: "Home", href: "/" },
  { label: "Events", href: "/events/" },
] as const;
