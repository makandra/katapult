require 'aruba/cucumber'
require 'pry'

# Make sure tests use the correct katapult gem
ENV['KATAPULT_GEMFILE_OPTIONS'] = ", path: '../../..'"

Aruba.configure do |config|
  config.exit_timeout = 5
end

Before do |scenario|
  # Don't reuse the Bundler environment of *katapult* during tests
  bundler_env_keys = aruba.environment.keys.grep /^BUNDLE/
  bundler_env_keys.each &method(:delete_environment_variable)

  # Katapult features usually stops Spring inside the generated applications
  # when they're done. However, when a test crashes or is canceled by Interrupt,
  # zombie instances of Spring continue to run although their cwd was clobbered
  # by Aruba. These Spring zombies would break subsequent test runs.
  `pkill -f '#{ RailsHelper::APP_DIRECTORIES.join '|' }'`

  scenario_tags = scenario.source_tag_names
  @no_clobber = scenario_tags.include? '@no-clobber'
end

After do
  # Spring doesn't like loosing its working directory. Since the test app
  # directory is clobbered between runs, we stop Spring after each run.
  run_simple 'spring stop'
end
