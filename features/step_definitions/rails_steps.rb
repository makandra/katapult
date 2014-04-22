Given /^a pristine Rails application$/ do
  @aruba_timeout_seconds = 20
  app_name = 'test_app'
  cache_name = 'cached_test_app'
  cache_path = File.join('tmp', cache_name)
  target_dir = File.join('tmp', 'aruba')

  # create cached rails app if missing
  unless File.directory?(cache_path)
    command = 'cd tmp; bundle exec rails new #{cache_name} --skip-test-unit'
    system(command) or raise "Rails app generation failed"
  end

  FileUtils.cp_r cache_path, File.join(target_dir, app_name)
  cd app_name
end
