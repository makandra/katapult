require 'capybara-screenshot/cucumber'

# Keep up to the number of screenshots specified in the hash
Capybara::Screenshot.prune_strategy = { keep: 10 }

# This asset host will become a `<base>` tag in the HTML's `<head>` and allow
# resolving test assets via the development Rails server. This makes HTML
# screenshots prettier.
# Note that *you won't be using development assets* but the compiled files from
# `RAILS_ROOT/public/packs-test/`.
Capybara.asset_host = 'http://localhost:3000/'
