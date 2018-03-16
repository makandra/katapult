When /^I run rspec/ do
  run_simple 'rspec', exit_timeout: 10
  run_simple 'bundle exec parallel_test -t rspec -- spec', exit_timeout: 10
end

When /^I run cucumber/ do
  run_simple 'bundle exec cucumber', exit_timeout: 15
  run_simple 'bundle exec parallel_test -t cucumber -- features', exit_timeout: 15
end

When 'debugger' do
  binding.pry
end
