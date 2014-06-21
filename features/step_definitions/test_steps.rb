Then /^the specs should pass$/ do
  prepare_environment do
    run_simple('bundle exec rspec')
  end
end
