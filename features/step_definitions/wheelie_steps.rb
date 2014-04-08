Given /^I install wheelie$/ do
  append_to_file 'Gemfile', "gem 'wheelie', :path => '#{Dir.pwd}'"
end

# When /^I generate code from the metamodel$/ do
#   run_simple 'bundle exec rails generate wheelie:model'
# end
