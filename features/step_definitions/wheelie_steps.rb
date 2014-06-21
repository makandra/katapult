When /^I( successfully)? render the metamodel$/ do |require_success|
  prepare_environment do
    success = run_simple('bundle exec rails generate wheelie:render lib/wheelie/metamodel.rb', !!require_success)

    if success
      # Using db:create:all would give missing/duplicate DB warnings because
      # Cucumber uses the test DB.
      run_simple('bundle exec rake db:drop db:create RAILS_ENV=development')
      run_simple('bundle exec rake db:drop db:create RAILS_ENV=test')
      run_simple('bundle exec rake db:migrate RAILS_ENV=test')
    end
  end
end
