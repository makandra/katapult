When /^I run rspec/ do
  run_simple 'rspec', exit_timeout: 10
end

When /^I run cucumber/ do
  # The test application's Bundler sees an empty BUNDLE_GEMFILE variable and
  # infers the wrong Gemfile location. Fixed by removing the var altogether.
  delete_environment_variable 'BUNDLE_GEMFILE'

  run_simple 'bundle exec cucumber', exit_timeout: 15
end

When 'debugger' do
  binding.pry
end
