When /^I install wheelie$/ do
  append_to_file 'Gemfile', "gem 'wheelie', path: '../../..'"
  run_simple('bin/rails generate wheelie:install')
end

# This step is required for any feature because it generates config/database.yml
When /^I generate wheelie basics$/ do
  run_simple('bundle exec rails generate wheelie:basics')
end

When /^I( successfully)? render the metamodel$/ do |require_success|
  # the second parameter would be true when not specified
  run_simple('bundle exec rails generate wheelie:render lib/wheelie/metamodel.rb', !!require_success)
end
