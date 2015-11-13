When /^I run rspec/ do
  run_simple 'rspec'
end

When /^I run cucumber/ do
  # The test application's Bundler sees an empty BUNDLE_GEMFILE variable and
  # infers the wrong Gemfile location. Fixed by removing the var altogether.
  delete_environment_variable 'BUNDLE_GEMFILE'

  run_simple 'bundle exec cucumber'
end
