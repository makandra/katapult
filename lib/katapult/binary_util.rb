# Utility methods.

# The Katapult::Util module is used inside the `katapult` script. It should not
# require any gems in order to prevent version conflicts.
require_relative '../katapult'
require 'bundler'

module Katapult
  module BinaryUtil
    extend self

    def git_commit(message, options = nil)
      message.gsub! /'/, "" # remove single quotes
      system "git add --all; git commit -m '#{ message }' --author='katapult <katapult@makandra.com>' #{ options }"
    end

    def create_rails_app(name)
      run "rails _#{ Katapult::RAILS_VERSION }_ new #{ name } --skip-test-unit --skip-bundle --database postgresql"
    end

    def puts(*args)
      message = "\n> #{ args.join ' ' }"
      Kernel.puts "\e[35m#{ message }\e[0m" # pink
    end

    # With clean Bundler env
    def run(command)
      success = Bundler.with_clean_env { system command }

      if !success
        puts 'x Something went wrong'
        exit(1)
      end
    end

  end
end
