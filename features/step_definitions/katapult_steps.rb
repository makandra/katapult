When /^I install katapult$/ do
  append_to_file 'Gemfile', "gem 'katapult', path: '../../..'"
  run_simple('bin/rails generate katapult:install')
end

# This step is required for any feature because it generates config/database.yml
When /^I generate katapult basics$/ do
  run_simple('bin/rails generate katapult:basics')
end

When /^I( successfully)? render the application model$/ do |require_success|
  # the second parameter would be true when not specified
  run_simple('bin/rails generate katapult:render lib/katapult/application_model.rb', !!require_success)
end
