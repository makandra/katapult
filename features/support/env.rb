require 'aruba/cucumber'
require 'pry'

Before do
  @aruba_timeout_seconds = 30
end

module Customization

  # Improve the internal #run method provided by Aruba::Api to run commands
  # with a clean bundler environment and without spring.
  def run(cmd, timeout = nil)
    ENV['DISABLE_SPRING'] = '1'
    Bundler.with_clean_env { super }
  end

end
World(Customization)
