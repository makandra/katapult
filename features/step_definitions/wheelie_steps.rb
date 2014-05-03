Given /^I install wheelie|wheelie is installed$/ do
  @aruba_timeout_seconds = 60

  append_to_file 'Gemfile', %{gem 'wheelie', :path => '#{Dir.pwd}'\n}

  Bundler.with_clean_env do
    run_simple 'bundle install'
    run_simple 'bundle exec rails generate wheelie:install'
  end
end

When /^I( successfully)? render the metamodel$/ do |require_success|
  Bundler.with_clean_env do
    run_simple('bundle exec rails generate wheelie:render lib/wheelie/metamodel.rb', !!require_success)
  end
end
