/* ============================================================
   R Snippet Library — shared mode configuration
   ------------------------------------------------------------
   Leave url + anonKey BLANK to run the offline, single-user app
   (everything stays in this browser's localStorage).

   Fill them in to turn on the shared, moderated, multi-user
   library backed by Supabase. Both values below are PUBLIC and
   safe to commit — access is enforced by Row-Level Security in
   the database. NEVER put the Supabase service_role key here.

   Setup:
     1. Create a free project at https://supabase.com
     2. Project Settings → API → copy "Project URL" and the
        "anon public" key into the fields below.
     3. Run supabase/schema.sql in the Supabase SQL editor.
     4. Add your email to the moderators table (see schema.sql).
   ============================================================ */
window.SNIPPET_CONFIG = {
  url: "",            // e.g. "https://abcdefgh.supabase.co"
  anonKey: "",        // the "anon public" key (safe to commit)
  signInRedirect: ""  // optional; defaults to the current page URL
};
