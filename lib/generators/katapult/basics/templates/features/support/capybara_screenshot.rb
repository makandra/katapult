require 'capybara-screenshot/cucumber'

# Keep up to the number of screenshots specified in the hash
Capybara::Screenshot.prune_strategy = { keep: 10 }
