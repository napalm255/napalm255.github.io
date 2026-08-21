# Brad Gibson's Resume

Personal resume site, served at [begibson.com](https://begibson.com) via GitHub Pages.

## Stack

- **Jekyll**, GitHub Pages' native static site generator. Templating (Liquid) happens
  entirely at build time — the published page has **no client-side JavaScript**.
- Plain hand-written CSS (`assets/main.css`), no framework.
- No external font/icon CDNs — system monospace font stack, dark mode via
  `prefers-color-scheme` (pure CSS, follows the visitor's OS setting, no toggle).

## Local development

Requires [Docker](https://docs.docker.com/get-docker/) with the Compose v2 plugin
(`docker compose`, not the older `docker-compose`).

```sh
docker compose up          # serve at http://localhost:4000
docker compose down        # stop and clean up
```

The repo is volume-mounted into the container, so edits to content, templates, and CSS
trigger Jekyll's auto-regeneration and the page live-reloads in the browser. **Editing
`_config.yml` is the exception** — it isn't watched, so restart the container to pick
those changes up.

The image is built only when it doesn't already exist. After changing `Gemfile`, force
a rebuild:

```sh
docker compose up --build
```

**File ownership:** the base image runs as root, so `docker-compose.yml` maps the
container user to uid/gid `1000` — otherwise generated files (`_site/`,
`.jekyll-cache/`) land root-owned in your working tree. If your account isn't uid 1000,
run `UID=$(id -u) GID=$(id -g) docker compose up` or set those in a `.env` file. If you
use **rootless podman** instead of Docker, remove the `user:` line — container root
already maps to your host user there.

## Deployment

There is no build/deploy pipeline in this repo. Pushing to `master` is deployment:
GitHub Pages detects the push, builds the site with Jekyll, and serves it at the custom
domain in `CNAME`.

Note that **GitHub Pages ignores this repo's `Gemfile` and `Gemfile.lock`.** It builds
with its own pinned `github-pages` gem release in `--safe` mode. The `Gemfile.lock`
here exists only to make *local* development reproducible and match production's
versions — bumping a gem in it does not change what production builds with. The
`Dockerfile` uses the `jekyll/jekyll:pages` image for the same reason: it tracks the
same `github-pages` gemset (currently Jekyll 3.10.0).

## Structure

```
_config.yml         Site config (title, name, position, url, exclude list)
_data/*.yml         All page content — contact, skills, work, edu, projects.
                    Edit these to update content; no HTML changes needed.
_includes/*.html    Liquid templates rendering each _data file into a section.
index.html          Page shell — meta/OG tags, header, assembles the includes.
assets/main.css     All styling, including dark mode and print rules.
images/user.png     Avatar shown in the header (also used as the OG preview image).
favicon.ico         Browser tab icon.
CNAME               Custom domain for GitHub Pages. Do not delete.
Gemfile(.lock)      Pins local dev to the github-pages gemset (see Deployment).
Dockerfile
docker-compose.yml  Local dev container running `jekyll serve --livereload`.
AGENTS.md           House rules for agents/contributors working in this repo.
```

To update resume content, edit the relevant file in `_data/` — no HTML/CSS knowledge
needed for text changes. Structural or visual changes go through `_includes/*.html`
and `assets/main.css`.

## Contributing / AI agents

See [AGENTS.md](AGENTS.md) for house rules (keep it JS-free, self-contained, and keep
this documentation in sync with the repo).
