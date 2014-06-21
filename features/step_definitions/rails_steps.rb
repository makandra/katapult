Given /^a pristine Rails application with wheelie installed$/ do
  app_name, cache_name = 'wheelie_test_app', 'cached_test_app'
  app_path = File.join('tmp', 'aruba', app_name)
  cache_path = File.join('tmp', cache_name)

  unless File.directory?(cache_path)
    puts 'Generating a cached rails app for testing ...'
    command = "cd tmp; bundle exec rails new #{cache_name} --skip-test-unit --skip-bundle --database mysql"
    system(command) or raise "Rails app generation failed"

    Bundler.with_clean_env do
      system <<-INSTALL_WHEELIE
        cd #{cache_path}
        echo "gem 'wheelie', path: '../../..'" >> Gemfile
        bundle install
        bundle exec rails generate wheelie:install
      INSTALL_WHEELIE
    end
  end

  # ensure cached_test_app is bundled
  Bundler.with_clean_env do
    bundle_check = "cd #{cache_path}; bundle check &>/dev/null"
    bundle_install = "cd #{cache_path}; bundle install"

    system(bundle_check) or system(bundle_install)
  end

  # cd to test_app
  FileUtils.cp_r cache_path, app_path
  cd app_name
end
