# Generates model-independent application basics (see method names).

module Katapult
  module Generators
    class BasicsGenerator < Rails::Generators::Base

      SKIP_GEMS = %w(sass-rails coffee-rails turbolinks sdoc uglifier mysql2)

      desc 'Generate basics like test directories and gems'
      source_root File.expand_path('../templates', __FILE__)

      class_option :db_user, type: :string,
        description: 'The user to set in config/database.yml'
      class_option :db_password, type: :string,
        description: 'The password to set in config/database.yml'


      def add_gitignore
        template '.gitignore', force: true
      end

      def write_ruby_version
        template '.ruby-version'
      end

      def write_database_ymls
        @db_user = options.db_user || 'root'
        @db_password = options.db_password || ''

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
        run 'bundle install'

        # There is a bug in the current version of Compass, so we use an older
        # one in our Gemfile template. Since its dependencies "sprockets" and
        # "sass-rails" are already in the Gemfile.lock (from installing Rails),
        # we need to explicitly update them.
        run 'bundle update sprockets sass-rails'
      end

      def remove_turbolinks_js
        gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''
      end

      def setup_spring
        # run 'spring binstub --all'
        # # remove_file 'bin/bundle' # Won't play together with parallel_tests
        # template 'config/spring.rb'
        # template 'bin/rake'
        run 'spring stop' # Reload (just in case)
      end

      def create_databases
        run 'rake db:create:all parallel:create'
      end

      def set_timezone
        gsub_file 'config/application.rb',
          /# config\.time_zone =.*$/,
          "config.time_zone = 'Berlin'"
      end

      def make_assets_debuggable
        gsub_file 'config/application.rb',
          /config\.assets\.debug =.*$/,
          'config.assets.debug = false'
      end

      def install_initializers
        directory 'config/initializers'
      end

      def add_modularity_load_paths
        # This results in correct indentation :)
        application <<-'LOAD_PATHS'
config.autoload_paths << "#{Rails.root}/app/controllers/shared"
    config.autoload_paths << "#{Rails.root}/app/models/shared"
    config.autoload_paths << "#{Rails.root}/app/util"
    config.autoload_paths << "#{Rails.root}/app/util/shared"
        LOAD_PATHS
      end

      def install_cucumber
        generate 'cucumber:install'
        directory 'features/support'
        template 'config/cucumber.yml', force: true

        # Remove cucumber section from database.yml. Don't need this.
        gsub_file 'config/database.yml', /^cucumber.*\z/m, ''
      end

      def install_rspec
        generate 'rspec:install'

        gsub_file '.rspec', "--warnings\n", '' # Don't show Ruby warnings
        uncomment_lines 'spec/rails_helper.rb', /Dir.Rails.root.join.+spec.support/
        template 'spec/support/shoulda_matchers.rb'
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

      def run(*)
        Bundler.with_clean_env do
          super
        end
      end

    end
  end
end
