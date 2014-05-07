When /^I( successfully)? render the metamodel$/ do |require_success|
  prepare_environment do
    run_simple('bundle exec rails generate wheelie:render lib/wheelie/metamodel.rb', !!require_success)
  end
end
