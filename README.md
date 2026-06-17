# R Snippet Library

A personal, offline-first code-snippet manager for R, aimed at epidemiological
research. The entire app is a single self-contained `index.html` — no server, no
build step, no dependencies, no internet required after the file loads. All
personal data persists in the browser's `localStorage`.

## Launch it

**▶ Live app (GitHub Pages):** https://nvangn77.github.io/r-snippet-library/

**Zero-setup preview (works from any branch, no Pages needed):**
https://htmlpreview.github.io/?https://raw.githubusercontent.com/nvangn77/r-snippet-library/main/index.html

**Locally (offline):** download `index.html` and double-click it — it opens in any
modern browser and works fully offline.

### One-time GitHub Pages setup

The app is a single static file, so Pages serves it straight from the branch — no
workflow or build needed. Configure it once:

1. Repo **Settings → Pages → Build and deployment**.
2. **Source = "Deploy from a branch"**, Branch = **`main`**, folder = **`/ (root)`**, Save.
3. Wait ~1 minute for the first build. The app is then live at the URL above.

Every later push to `main` redeploys automatically. The `.nojekyll` file ensures
the HTML is served verbatim (no Jekyll processing).

## Sharing snippets between people

The committed `index.html` ships the **shared default library** (~72 snippets)
that every visitor sees. Each person's own additions live only in their browser's
`localStorage`, so to contribute them to the shared library:

1. **More ⋯ → Export JSON** to download your snippets.
2. Open a PR adding those entries to the `DEFAULT_SNIPPETS` array in `index.html`
   (or share the JSON for someone to merge). Import dedupes by `id`, so merging is
   safe.

> Want *live* multi-user uploads instead of the export→merge flow? Turn on **shared
> mode** below.

## Shared mode (multi-user, moderated, durable)

By default the app runs offline in `localStorage`. Filling in `config.js` switches it to
a shared library where **anyone can submit** a snippet and **you (the owner) approve**
what becomes public — backed by [Supabase](https://supabase.com) (hosted Postgres + auth).
The frontend stays the same vanilla-JS file on GitHub Pages.

**How it behaves**
- Visitors see only **approved** snippets and can **+ Submit** new ones → they land in a
  pending queue (a database rule forces this; nobody can self-publish).
- You **Sign in** (one-time email link). As a moderator you get a **⚑ Review queue** with
  **Approve / Reject / Edit**, plus edit/delete on the live library.
- Works offline too: the last approved list is cached in `localStorage`, so the page still
  renders if the backend is unreachable.

**Setup (one time)**
1. Create a free **Supabase** project.
2. In Supabase **SQL editor**, run [`supabase/schema.sql`](supabase/schema.sql) (table,
   moderation rules / RLS, triggers).
3. Add yourself as moderator:
   `insert into public.moderators (email) values ('you@example.com');`
4. **Project Settings → API**: copy the **Project URL** and **anon public** key into
   [`config.js`](config.js) (both are safe to commit; security is enforced by RLS).
5. Commit & push. Open the site, sign in, and click **"Publish the 72 default snippets"**
   on the empty state to seed the library.

> Never commit the Supabase **service_role** key. It belongs only in the backup secret below.

## Protection against data loss (backups)

Two independent copies, so a backend failure never loses the library:
- **Supabase** keeps its own managed backups (enable point-in-time recovery on a paid tier).
- **Daily git snapshot:** [`.github/workflows/backup.yml`](.github/workflows/backup.yml)
  exports the whole table to `data/snippets-backup.json` and commits it — versioned,
  off-site, free. Add two repo **secrets** for it: `SUPABASE_URL` and `SUPABASE_SERVICE_KEY`
  (the service_role key). It also runs on demand from the **Actions** tab.

**Restore:** open the latest `data/snippets-backup.json` from git history and either import it
via the app, or re-insert it with the Supabase API. The JSON format matches the app's
export/import, which dedupes by `id`.

## Features

- Add / edit / delete / **duplicate** snippets — title, code, description,
  category, tags, timestamps. Persisted under `localStorage` key `r-snippets-v4`.
- Sidebar of 20 categories (grouped in 4 sections) with live counts.
- Full-text search across title, description, code and tags (`/` focuses search,
  `Esc` clears).
- **Clickable tags** + a **tag browser** panel listing every tag with counts.
- **Sort** by newest, recently updated, A–Z, or category, with a filtered count.
- Inline **SVG visualization previews** (25 types) that adapt to light/dark mode.
- Light / dark theme toggle (off-white `#F5F4F0` light, `#1A1A1D` dark, sage accent).
- Export / import JSON (dedup by `id`) and reset to factory defaults.

## Constraints

No frameworks, no compilation step. In the default **local mode** everything lives in one
portable `index.html` with zero external calls. **Shared mode** is opt-in (via `config.js`)
and is the only path that talks to the network — it loads `supabase-js` and calls your
Supabase project; with no keys configured, none of that loads.
