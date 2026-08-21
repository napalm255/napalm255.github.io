# AGENTS.md

Instructions for any AI coding agent (or human) working in this repo.

## What this is

A single-page Jekyll resume, deployed to GitHub Pages at begibson.com. See
[README.md](README.md) for the stack, local dev, and deployment overview — read it
first.

## House rules

- **Stay JS-free.** This site intentionally ships zero client-side JavaScript. Don't
  add a `<script>` tag, a JS dependency, or a client-side framework to solve a problem
  that CSS or Jekyll/Liquid (build-time templating) can solve instead. If a task
  genuinely requires JS, stop and confirm with the user first — this is a deliberate
  constraint, not an oversight.
- **Stay self-contained.** No external CDNs (fonts, icon libraries, JS libraries,
  analytics, etc.). Fonts are the system monospace stack; icons, if ever needed, should
  be inline SVG or Unicode, not an icon-font dependency.
- **Content lives in `_data/*.yml`, not in HTML.** Adding/editing a skill, job,
  education entry, or project means editing the corresponding YAML file, not the
  `_includes/*.html` templates. Only touch `_includes/` when the *structure* of a
  section needs to change.
- **Respect the GitHub Pages plugin allowlist.** Production builds in `--safe` mode
  with GitHub's own pinned `github-pages` gem, and **ignores this repo's `Gemfile`**.
  A plugin added to `_config.yml` can work perfectly in local dev and be silently
  ignored in production. Only use plugins on
  [GitHub's allowlist](https://pages.github.com/versions/), and verify against a real
  deploy — not just localhost.
- **Preserve print support.** The site is used as an actual printable/PDF resume.
  Any CSS change must be checked against `@media print` in `assets/main.css` — don't
  let a visual change silently break the printed layout (e.g. dark backgrounds bleeding
  into print, entries splitting across pages, content clipped by a fixed max-width).
- **Dark mode is automatic, not toggled.** It's driven by `prefers-color-scheme` only.
  Don't add a manual light/dark toggle (that would require JS) unless the user
  explicitly asks for one and accepts the JS tradeoff.
- **Escape interpolated data.** Liquid does not auto-escape in Jekyll. Use
  `{{ value | escape }}` when rendering anything from `_data/` so an `&` or `<` in
  content can't produce invalid HTML.

## Keeping documentation current

**Documentation must never drift from what's actually true.** Whenever a change
affects any of the following, update `README.md` and/or this file in the *same*
change — not as a follow-up:

- Site structure (new/removed sections, pages, or `_data`/`_includes` files)
- The local dev workflow (Docker setup, commands, ports, the container image or tag,
  `Gemfile` changes)
- The deployment model
- Any house rule above (e.g. if the user explicitly approves adding JS, update the
  JS-free rule to reflect the new reality rather than leaving it stale)

If you're not sure whether a change is documentation-worthy, err on the side of
updating the docs.

## Verifying changes

Before considering a change done:

1. Run it locally: `docker compose up`, check `http://localhost:4000`.
2. Check both color schemes (OS/browser dark-mode toggle, or devtools
   `prefers-color-scheme` emulation), and check a narrow viewport (~360px).
3. Check print output (browser print preview) if CSS or markup changed.
4. **Verify the JS-free and no-CDN invariants against a plain build, not the dev
   server.** `jekyll serve --livereload` injects a `livereload.js` `<script>` into every
   page it serves — that is dev-only and never present in `_site`. Checking the browser
   would flag a false violation every time. Instead:

   ```sh
   docker compose run --rm site bundle exec jekyll build
   grep -r "<script" _site/index.html          # must return nothing
   grep -rE "https?://(fonts|cdn|maxcdn)" _site/index.html   # must return nothing
   ```
5. Confirm no root-owned files were left behind: `ls -ld _site` should show your own
   user, and `rm -rf _site` should succeed without sudo.
