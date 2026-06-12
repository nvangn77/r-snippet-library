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

Deployment is automated by [`.github/workflows/deploy-pages.yml`](.github/workflows/deploy-pages.yml),
so you only configure Pages once:

1. Merge this to the **default branch** (`main`).
2. Repo **Settings → Pages → Build and deployment → Source = "GitHub Actions"**.
3. Done. Every push to `main` redeploys automatically; the live URL above stays
   current. You can also trigger a deploy manually from the **Actions** tab
   ("Deploy to GitHub Pages" → *Run workflow*).

## Sharing snippets between people

The committed `index.html` ships the **shared default library** (~72 snippets)
that every visitor sees. Each person's own additions live only in their browser's
`localStorage`, so to contribute them to the shared library:

1. **More ⋯ → Export JSON** to download your snippets.
2. Open a PR adding those entries to the `DEFAULT_SNIPPETS` array in `index.html`
   (or share the JSON for someone to merge). Import dedupes by `id`, so merging is
   safe.

> Want *live* real-time multi-user uploads instead of the export→merge flow? That
> requires a backend (e.g. Node + SQLite, or Supabase) and is a deliberate
> departure from the offline single-file design — a separate follow-up.

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

No frameworks, no compilation step, no external CDN calls — everything lives in
one portable `index.html`.
