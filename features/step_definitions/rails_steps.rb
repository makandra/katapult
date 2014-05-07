Given /^a pristine Rails application with wheelie installed$/ do
  @aruba_timeout_seconds = 60
  app_name, cache_name = 'test_app', 'cached_test_app'
  app_path = File.join('tmp', 'aruba', app_name)
  cache_path = File.join('tmp', cache_name)

  unless File.directory?(cache_path)
    puts 'Generating a cached rails app for testing ...'
    command = "cd tmp; bundle exec rails new #{cache_name} --skip-test-unit --skip-bundle"
    system(command) or raise "Rails app generation failed"

    Bundler.with_clean_env do
      system <<-INSTALL_WHEELIE
        cd #{cache_path}
        echo "gem 'wheelie', :path => '#{Dir.pwd}'\n" >> Gemfile
        bundle install
        bundle exec rails generate wheelie:install
      INSTALL_WHEELIE
    end
  end

  FileUtils.cp_r cache_path, app_path
  cd app_name
end
