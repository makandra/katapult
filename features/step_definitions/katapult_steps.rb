# Note: Aruba adds the project's bin/ directory to the path

When /^I install katapult$/ do
  append_to_file 'Gemfile', "gem 'katapult', path: '../../..'"
  run_simple 'rails generate katapult:install'
end

# This step is required for any feature because it generates config/database.yml
When /^I generate katapult basics$/ do
  with_aruba_timeout 45 do
    run_simple 'rails generate katapult:basics --db-user katapult --db-password secret'
  end
end

When /^I( successfully)? transform the application model$/ do |require_success|
  # the second parameter would be true when not specified
  with_aruba_timeout 45 do
    run_simple 'rails generate katapult:transform lib/katapult/application_model.rb', !!require_success
  end
end
