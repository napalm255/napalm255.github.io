# Matches what GitHub Pages actually builds with: the `pages` tag tracks the
# github-pages gem (Jekyll 3.x), so local output matches production.
FROM jekyll/jekyll:pages

WORKDIR /srv/jekyll

# Copy the lock too, so the build honors pinned versions instead of resolving
# whatever is newest. BUNDLE_FROZEN makes a lock/Gemfile mismatch fail loudly.
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN bundle install
