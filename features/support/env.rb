require 'aruba/cucumber'
require 'pry'

Before do
  @aruba_timeout_seconds = 30

  unset_bundler_env_vars
  run_simple 'spring stop # Clean up in case the After hook did not run'
end

After do
  run_simple 'spring stop'
end
