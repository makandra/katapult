require 'aruba/cucumber'
require 'pry'

def in_test_app(&block)
  in_current_dir do
    Bundler.with_clean_env(&block)
  end
end

After do
  in_test_app do
    system 'spring stop > /dev/null 2>&1'
  end
end
