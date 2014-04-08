Given /^a pristine Rails application$/ do
  @aruba_timeout_seconds = 20

  run_simple 'bundle exec rails new test_app --skip-test-unit'
  assert_passing_with('README')

  cd 'test_app'
end
