require 'aruba/cucumber'
require 'pry'

Before do
  @aruba_timeout_seconds = 30

  run_simple 'spring stop # Clean up in case the After hook did not run'
end

After do
  run_simple 'spring stop'
end

module Customization

  # Improve the internal #run method provided by Aruba::Api to run commands
  # with a clean bundler environment.
  def run(*args)
    Bundler.with_clean_env do
      super
    end
  end

end
World(Customization)
