Given /^I install wheelie|wheelie is installed$/ do
  @aruba_timeout_seconds = 20

  append_to_file 'Gemfile', %{gem 'wheelie', :path => '#{Dir.pwd}'\n}

  run_simple 'bundle exec rails generate wheelie:install'
end

Given /^I copy the "(.*?)" driver to "(.*?)"$/ do |source, target|
  run_simple "bundle exec rails generate wheelie:driver #{target} --source #{source}"
end

When /^the metamodel is( successfully)? rendered(?: driven by "(.*?)")?$/ do |require_success, driver|
  command = 'bundle exec rails generate wheelie:render lib/wheelie/metamodel.rb'
  command << " --driver #{ driver }" if driver

  in_test_app do
    run_simple(command, !!require_success)
  end
end
