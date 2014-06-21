require 'aruba/cucumber'
require 'pry'

Before do
  @aruba_timeout_seconds = 120 # bundling takes time
end

# Use this method to wrap any system calls to the test application
def prepare_environment(&block)
  Bundler.with_clean_env do
    # Spring leads to all kinds of unexpected behavior in tests.
    ENV['DISABLE_SPRING'] = '1'

    block.call
  end
end
