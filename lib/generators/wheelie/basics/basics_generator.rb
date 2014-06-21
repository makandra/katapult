require 'wheelie/generator'
require 'bundler'

module Wheelie
  module Generators
    class BasicsGenerator < Wheelie::Generator

      desc 'Generate basics like test directories and gems'

      source_root File.expand_path('../templates', __FILE__)

      # We don't want to overwrite the database.yml file once we generated it so
      # a user can make configurations. The sample file is taken as indicator
      # that we've already generated it.
      def write_database_ymls
        unless File.exists?('config/database.sample.yml')
          template 'config/database.yml', force: true
          template 'config/database.sample.yml'
        end
      end

      def install_gemfile
        Bundler.with_clean_env do
          @rails_version = `bundle exec rails -v`[/Rails (\d.\d.\d)/, 1]
        end

        template 'Gemfile', force: true

        say_status :run, 'bundle install'
        Bundler.clean_system 'bundle install'
      end

      # def install_cucumber
      #   generate 'cucumber:install'
      # end

      def install_rspec
        generate 'rspec:install'

        # Do not show Ruby warnings in RSpec runs == do not be $VERBOSE.
        gsub_file '.rspec', "--warnings\n", ''
      end

      # def install_capistrano
      #   capify!
      #   template 'config/deploy.rb'
      # end

      private

      def app_name
        File.basename(Dir.pwd)
      end

    end
  end
end
