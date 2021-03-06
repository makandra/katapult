# Utility methods.

# This module is used inside the `katapult` binary and thus should not
# require any gems in order to prevent version conflicts

require_relative '../../katapult/version'
require 'bundler'
require 'io/console'

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
        --database postgresql
        --webpack

        --skip-test
        --skip-system-test
        --skip-turbolinks
      ]

      success = run "rails _#{version}_ new #{name} " + options.join(' ')
      success or fail 'Failed to create Rails app'
    end

    def pink(*args, linefeed: true)
      message = "> #{ args.join ' ' }"
      message.prepend($/) if linefeed
      message << (linefeed ? $/ : ' ')

      pink_message = "\e[35m#{ message }\e[0m"
      print pink_message
    end

    def ask(question)
      pink(question, linefeed: false)
      gets.chomp
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

    def snake_case(string)
      string.gsub(/([a-z])([A-Z])/,'\1_\2').downcase
    end

  end
end
