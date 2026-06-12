# R Snippet Library

A personal, offline-first code-snippet manager for R, aimed at epidemiological
research. The entire app is a single self-contained `index.html` — no server, no
build step, no dependencies, no internet required after the file loads. All
personal data persists in the browser's `localStorage`.

## Run it

**Locally (offline):** download `index.html` and open it directly in any modern
browser. It works fully offline.

**Online / shared (GitHub Pages):** the same file is served as a static site so
several people can reach it from one URL.

1. Push to the default branch.
2. Repo **Settings → Pages → Build and deployment**, Source = *Deploy from a
   branch*, Branch = your default branch, folder = `/ (root)`.
3. The app is published at `https://<user>.github.io/<repo>/`.

No workflow file is needed — it's a single static HTML file.

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
