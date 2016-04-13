require 'katapult/binary_util'

module KatapultRailsHelper

  def with_aruba_timeout(timeout, &block)
    original_aruba_timeout = aruba.config.exit_timeout
    aruba.config.exit_timeout = timeout.to_i
    # print "(timeout: #{ timeout })"

    block.call
  ensure
    aruba.config.exit_timeout = original_aruba_timeout
  end

  def create_cached_app(name)
    job = 'Cached Rails app generation'

    puts "#{job} started (in #{Dir.pwd})"
    Katapult::BinaryUtil.create_rails_app(name)
    puts "#{job} done."
  end

  def ensure_bundled(path)
    Dir.chdir(path) do
      Bundler.with_clean_env do
        system('bundle check > /dev/null 2>&1') or system('bundle install')
      end
    end
  end

end
World(KatapultRailsHelper)


Given /^a pristine Rails application$/ do
  with_aruba_timeout(120) do
    Dir.chdir('tmp') do
      create_cached_app('cached_test_app') unless File.directory?('cached_test_app')
      ensure_bundled('cached_test_app')
    end

    # copy cached app to aruba directory
    FileUtils.cp_r 'tmp/cached_test_app', File.join(expand_path('.'), 'katapult_test_app')
    cd 'katapult_test_app' # Aruba::Api method
  end
end
