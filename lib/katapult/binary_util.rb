# Utility methods.

# This module is used inside the `katapult` binary and thus should not
# require any gems in order to prevent version conflicts
require_relative '../katapult/version'
require 'bundler'

module Katapult
  module BinaryUtil
    extend self

    def git_commit(message, options = nil)
      message.gsub! /'/, "" # remove single quotes
      system "git add --all; git commit -m '#{ message }' --author='katapult <katapult@makandra.com>' #{ options }"
    end

    def create_rails_app(name)
      version = Katapult::RAILS_VERSION
      options = %w[
        --skip-test
        --skip-system-test
        --skip-bundle
        --database postgresql
        --skip-turbolinks
      ]

      run "rails _#{version}_ new #{name} " + options.join(' ')
    end

    def pink(*args)
      message = "\n> #{ args.join ' ' }"
      Kernel.puts "\e[35m#{ message }\e[0m" # pink
    end

    # With clean Bundler env
    def run(command)
      success = Bundler.with_clean_env { system command }
      success or fail 'Something went wrong'
    end

    def job(do_something, done = 'Done.', &job)
      pink "About to #{do_something}. [C]ontinue, [s]kip or [e]xit?"

      case $stdin.getch
      when 's' then puts('Skipped.')
      when 'e' then fail('Cancelled.')
      else
        job.call
        puts done
      end
    end

    def fail(message)
      puts "x #{message}"
      exit(1)
    end

  end
end
