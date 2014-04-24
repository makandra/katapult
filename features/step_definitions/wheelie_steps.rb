Given /^I install wheelie$/ do
  @aruba_timeout_seconds = 20

  append_to_file 'Gemfile', %{gem 'wheelie', :path => '#{Dir.pwd}'\n}

  run_simple 'bundle exec rails generate wheelie:install'
end

When /^I( successfully)? render the metamodel$/ do |require_success|
  in_test_app do
    run_simple('bundle exec rails generate wheelie:render lib/wheelie/metamodel.rb', !!require_success)
  end
end
