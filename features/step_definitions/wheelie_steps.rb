# This step is required for any feature because it generates config/database.yml
When /^I generate wheelie basics$/ do
  prepare_environment do
    run_simple('bundle exec rails generate wheelie:basics')
  end
end

When /^I( successfully)? render the metamodel$/ do |require_success|
  prepare_environment do
    success = run_simple('bundle exec rails generate wheelie:render lib/wheelie/metamodel.rb', !!require_success)

    if success
      # run_simple('bundle exec rake db:drop db:create db:migrate RAILS_ENV=development')
      run_simple('bundle exec rake db:drop db:create db:migrate RAILS_ENV=test')
    end
  end
end
