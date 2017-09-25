require 'aruba/cucumber'
require 'pry'

# Make sure tests use the correct katapult gem
ENV['KATAPULT_GEMFILE_OPTIONS'] = ", path: '../../..'"

Aruba.configure do |config|
  config.exit_timeout = 30 # Todo: decrease to ~5
end

Before do
  unset_bundler_env_vars # Don't use katapult's Bundler environment inside tests
  run_simple 'spring stop # Ensure Spring is not running'
end

After do
  # Spring doesn't like loosing its working directory. Since the test app
  # directory is clobbered between runs, we stop Spring after each run.
  run_simple 'spring stop'
end
