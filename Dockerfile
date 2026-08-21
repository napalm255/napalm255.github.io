# Matches what GitHub Pages actually builds with: the `pages` tag tracks the
# github-pages gem (Jekyll 3.x), so local output matches production.
FROM jekyll/jekyll:pages

WORKDIR /srv/jekyll

# Copy the lock too, so the build honors pinned versions instead of resolving
# whatever is newest. BUNDLE_FROZEN makes a lock/Gemfile mismatch fail loudly.
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN bundle install

# Don't run as root: generated files land on a host bind mount, and root-owned
# _site/ needs sudo to clean up. HOME must be writable for this uid or bundler
# has nowhere to write. docker-compose.yml overrides the uid for hosts where
# it isn't 1000.
ENV HOME=/tmp
USER 1000:1000
