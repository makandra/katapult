module Wheelie
  module Generators
    class BasicsGenerator < Rails::Generators::Base

      SKIP_GEMS = %w(sass-rails coffee-rails turbolinks sdoc uglifier)

      desc 'Generate basics like test directories and gems'
      source_root File.expand_path('../templates', __FILE__)


      def write_database_ymls
        template 'config/database.yml', force: true
        template 'config/database.sample.yml'
      end

      # Overwrite Gemfile with the template, but transfer all gems that are not
      # skipped (see SKIP_GEMS).
      def enhance_gemfile
        gem_lines = File.readlines('Gemfile').select{ |line| line =~ /^gem/ }
        @original_gems = gem_lines.reject do |line|
          line =~ /'(#{ SKIP_GEMS.join '|' })'/
        end

        template 'Gemfile', force: true
      end

      def bundle_install
        bundle 'install'
      end

      def remove_turbolinks_js
        gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''
      end

      def setup_spring
        bundle 'exec spring binstub --all'
        template 'config/spring.rb'
        run 'spring stop' # reload
      end

      def add_modularity_load_paths
        # This results in correct formatting :)
        application <<-'LOAD_PATHS'
config.autoload_paths << "#{Rails.root}/app/controllers/shared"
    config.autoload_paths << "#{Rails.root}/app/models/shared"
    config.autoload_paths << "#{Rails.root}/app/util"
    config.autoload_paths << "#{Rails.root}/app/util/shared"
        LOAD_PATHS
      end

      def install_cucumber
        generate 'cucumber:install'

        template 'features/support/paths.rb'
        template 'features/support/env-custom.rb'
      end

      def install_rspec
        generate 'rspec:install'

        # Do not show Ruby warnings in RSpec runs.
        gsub_file '.rspec', "--warnings\n", ''

        inject_into_file 'spec/rails_helper.rb', after: "require 'rspec/rails'\n" do
          "require 'shoulda/matchers'\n"
        end
      end

      def install_styles
        remove_file 'app/assets/stylesheets/application.css'
        directory 'app/assets/stylesheets', force: true
      end

      # def install_capistrano
      #   capify!
      #   template 'config/deploy.rb'
      # end

      private

      def app_name
        File.basename(Dir.pwd)
      end

      def bundle(command)
        Bundler.with_clean_env do
          run 'bundle ' + command
        end
      end

    end
  end
end
