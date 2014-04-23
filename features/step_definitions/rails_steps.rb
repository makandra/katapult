Given /^a pristine Rails application$/ do
  @aruba_timeout_seconds = 20
  app_name, cache_name = 'test_app', 'cached_test_app'
  app_path = File.join('tmp', 'aruba', app_name)
  cache_path = File.join('tmp', cache_name)

  # create cached rails app if missing
  unless File.directory?(cache_path)
    command = "cd tmp; bundle exec rails new #{cache_name} --skip-test-unit"
    system(command) or raise "Rails app generation failed"
  end

  FileUtils.cp_r cache_path, app_path
  cd app_name
end
