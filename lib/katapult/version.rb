module Katapult
  ruby_version_path = File.expand_path('../../.ruby-version', __dir__)

  VERSION = '0.5.1'
  RUBY_VERSION = File.read(ruby_version_path).strip
  RAILS_VERSION = '5.2.2'
end
