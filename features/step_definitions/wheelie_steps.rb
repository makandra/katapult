Given /^I install wheelie$/ do
  @aruba_timeout_seconds = 20

  append_to_file 'Gemfile', "gem 'wheelie', :path => '#{Dir.pwd}'"

  run_simple 'bundle exec rails generate wheelie:install'
  assert_success true
end

# When /^I generate code from the metamodel$/ do
#   run_simple 'bundle exec rails generate wheelie:model'
# end
