require 'katapult/binary_util'

module RailsHelper

  # Directory names
  TEST_APP = 'katapult_test_app'
  APP_WITH_BASICS = 'cached_test_app_with_basics'
  PRISTINE_APP = 'cached_pristine_test_app'

  def with_aruba_timeout(timeout, &block)
    original_aruba_timeout = aruba.config.exit_timeout
    aruba.config.exit_timeout = timeout.to_i
    # print "(timeout: #{ timeout })"

    block.call
  ensure
    aruba.config.exit_timeout = original_aruba_timeout
  end

  def create_app(name)
    Katapult::BinaryUtil.create_rails_app(name)
    puts 'Done generating rails app.'
  end

  def test_app_path
    File.join expand_path('.'), TEST_APP
  end

  def ensure_bundled(path)
    Dir.chdir(path) do
      Bundler.with_clean_env do
        system('bundle check > /dev/null 2>&1') or system('bundle install')
      end
    end
  end

  def recreate_databases(path)
    Dir.chdir(path) do
      # Katapult doesn't run test app tests in parallel
      Katapult::BinaryUtil.run 'bundle exec rake db:drop db:create > /dev/null'
    end
  end

end
World(RailsHelper)

# In these steps, cached Rails apps are created to speed up test runs.
#
# Note: The current Ruby process and Aruba have *different* opinions about the
# current working directory:
# - Ruby knows the "real" Dir.pwd
# - Aruba is scoped to its test directory "tmp/aruba"

Given /^a pristine Rails application$/ do
  unless @no_clobber
    with_aruba_timeout(80) do
      # Change Ruby cwd
      Dir.chdir('tmp') do
        if File.directory?(RailsHelper::PRISTINE_APP)
          puts "Using a cached Rails app from tmp/#{RailsHelper::PRISTINE_APP}"
        else
          create_app(RailsHelper::PRISTINE_APP)
        end

        ensure_bundled(RailsHelper::PRISTINE_APP)
        FileUtils.cp_r RailsHelper::PRISTINE_APP, test_app_path
      end
    end
  end

  cd RailsHelper::TEST_APP # Change Aruba cwd
end

Given 'a new Rails application with Katapult basics installed' do
  unless @no_clobber
    with_aruba_timeout(120) do
      # Change Ruby cwd
      Dir.chdir('tmp') do
        if File.directory?(RailsHelper::APP_WITH_BASICS)
          puts <<-NOTE
  Using a cached Rails app with basics installed. Remember to
    rm -rf tmp/#{RailsHelper::APP_WITH_BASICS}
  when modifying the basics generator.
        NOTE
        else
          create_app(RailsHelper::APP_WITH_BASICS)

          Dir.chdir(RailsHelper::APP_WITH_BASICS) do
            # :path will be correct when copied to the TEST_APP path
            Katapult::BinaryUtil.run %(echo "gem 'katapult', path: '../../..'" >> Gemfile)
            Katapult::BinaryUtil.run 'bin/rails generate katapult:basics --db-user katapult --db-password secret'
            # Spring running in the cache dir is of no further use
            Katapult::BinaryUtil.run 'spring stop'
          end
        end

        ensure_bundled(RailsHelper::APP_WITH_BASICS)
        recreate_databases(RailsHelper::APP_WITH_BASICS)
        FileUtils.cp_r RailsHelper::APP_WITH_BASICS, test_app_path
      end
    end
  end

  cd RailsHelper::TEST_APP # Change Aruba cwd
end
