module WheelieRailsHelper

  def with_aruba_timeout(timeout, &block)
    original_aruba_timeout = @aruba_timeout_seconds
    @aruba_timeout_seconds = timeout

    block.call
  ensure
    @aruba_timeout_seconds = original_aruba_timeout
  end

  def create_cached_app(name)
    job = 'Cached Rails app generation'
    rails_new_command = "bundle exec rails new #{name} --skip-test-unit --skip-bundle --database mysql"

    puts "#{job} started (in #{Dir.pwd})"
    system(rails_new_command) or raise "#{job} failed"
    puts "#{job} done."
  end

  def ensure_bundled(path)
    Dir.chdir(path) do
      Bundler.with_clean_env do
        system('bundle check &> /dev/null') or system('bundle install')
      end
    end
  end

end
World(WheelieRailsHelper)


Given /^a pristine Rails application$/ do
  with_aruba_timeout(120) do
    Dir.chdir('tmp') do
      create_cached_app('cached_test_app') unless File.directory?('cached_test_app')
      ensure_bundled('cached_test_app')
    end

    # copy cached app to aruba directory
    FileUtils.cp_r('tmp/cached_test_app', File.join(current_dir, 'wheelie_test_app'))
    cd 'wheelie_test_app' # Aruba::Api method
  end
end
