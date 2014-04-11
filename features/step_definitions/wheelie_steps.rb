Given /^I install wheelie$/ do
  @aruba_timeout_seconds = 20

  append_to_file 'Gemfile', %{gem 'wheelie', :path => '#{Dir.pwd}'\n}

  run_simple 'bundle exec rails generate wheelie:install'
  assert_success true # needed?
end

When /^the metamodel is rendered$/ do
  Bundler.with_clean_env do
    run_simple 'bundle exec rails generate wheelie:render'
  end
end
