# Generates model-independent application basics (see method names).

require 'katapult/support/generator_goodies'
require 'katapult/version' # For writing .ruby-version

module Katapult
  module Generators
    class BasicsGenerator < Rails::Generators::Base
      include Katapult::GeneratorGoodies

      WEBPACK_DIR = 'app/webpack'
      YARN_PACKAGES = %w[
        autoprefixer
        autosize
        bootstrap-sass
        jquery
        jquery-ujs
        unpoly
      ]

      desc 'Generate basics like test directories and gems'
      source_root File.expand_path('../templates', __FILE__)

      class_option :db_user, type: :string, default: '',
        description: 'The user to set in config/database.yml'
      class_option :db_password, type: :string, default: '',
        description: 'The password to set in config/database.yml'

      def add_basic_files
        template '.ruby-version'
        template '.gitignore', force: true
        template 'public/robots.txt', force: true
        template 'README.md', force: true
      end

      # Gems ###################################################################

      def enhance_gemfile
        # Need to transfer the katapult line, because in tests, katapult is
        # installed with a custom :path option
        @katapult = File.readlines('Gemfile').find{ |line| line =~ /^gem 'katapult'/ }
        template 'Gemfile', force: true
      end

      def bundle_install
        run 'bundle install'

        # Fix Bundler for parallel_tests
        run 'bundle config --local disable_exec_load true'

        # This is relevant for the server, so it may happen after bundling here.
        # By having Nokogiri use system libraries, it will get automatic updates
        # of the frequently broken libxml (i.e. when the system libxml updates).
        run 'bundle config --local build.nokogiri --use-system-libraries'
      end


      # Database ###############################################################

      def write_database_ymls
        @db_user = options.db_user
        @db_password = options.db_password

        template 'config/database.yml', force: true
        template 'config/database.sample.yml'
      end

      def create_databases
        # Need to unset RAILS_ENV variable for this sub command because
        # parallel_tests defaults to "test" only if the variable is not set (<->
        # empty string value). However, because this is run from a Rails
        # generator, the variable is already set to "development". Cannot set to
        # "test" either because parallel_tests is only loaded in development.
        run 'unset RAILS_ENV; bundle exec rake db:drop db:create parallel:drop parallel:create'
      end


      # Configure Rails ########################################################

      def install_application_layout
        remove_file 'app/views/layouts/application.html.erb'
        directory 'app/views/layouts'
      end

      # We're using Webpacker
      def remove_asset_pipeline_traces
        remove_dir 'app/assets'
      end

      def disable_migration_errors
        development = 'config/environments/development.rb'
        gsub_file development, /(migration_error =) :page_load/, '\1 false'
      end

      def setup_staging
        template 'config/environments/staging.rb'

        # Cheating in the "staging" secret between "test" and "production"
        secret = run('bundle exec rake secret', capture: true).chomp
        insert_into_file 'config/secrets.yml', <<~SECRET, after: "test:\n"
          secret_key_base: #{ secret }

        staging:
        SECRET
      end

      def configure_test_environment
        test_env = 'config/environments/test.rb'

        gsub_file test_env,
          /# Do not eager load code on boot.*config\.eager_load = false/m,
          'config.eager_load = true'
        gsub_file test_env,
          /  # Show full error.*\n  config\.consider_all_requests_local\s.*$/,
          '  config.consider_all_requests_local = false'
        gsub_file test_env,
          /  # Disable request forgery protection.*\n  config\.action_controller\.allow_forgery_protection\s.*$\n/,
          ''
        gsub_file test_env, /config\.action_controller\.perform_caching\s.*$/,
          'config.action_controller.perform_caching = true'
      end

      def configure_action_mailer
        app_con = 'app/controllers/application_controller.rb'
        inject_into_file app_con, <<-CONFIG, before: /end\n\z/
  before_action :make_action_mailer_use_request_host_and_protocol

  private

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
        CONFIG

        gsub_file 'app/mailers/application_mailer.rb',
          /(^\s+default from:).*$/, '\1 Rails.configuration.system_email'
      end

      def set_timezone
        # This results in correct indentation :)
        application <<-'LOAD_PATHS'
config.time_zone = 'Berlin'
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false
    LOAD_PATHS
        gsub_file 'config/application.rb',
          /# config\.time_zone =.*$/,
          "config.time_zone = 'Berlin'"
      end

      def configure_system_email
        application "config.system_email = 'system@#{app_name}.com'\n"
      end

      def disable_asset_debugging # Faster
        gsub_file 'config/environments/development.rb',
          /config\.assets\.debug =.*$/,
          'config.assets.debug = false'
      end

      def install_helpers
        directory 'app/helpers'
      end

      def install_errors_controller
        template 'app/controllers/errors_controller.rb'
        route 'resources :errors, only: :new'
      end

      def install_initializers
        directory 'config/initializers'
      end

      def install_ext
        directory 'lib/ext'
      end


      # Configure 3rd party ####################################################

      def setup_spring
        run 'spring binstub --all'

        # Enhance Spring config
        config = 'config/spring.rb'
        inject_into_file config, <<-DIR, after: /\A%w\(\n/
  lib/templates
        DIR
        prepend_to_file config, <<-MKDIR
# Custom generator templates are put into lib/templates
FileUtils.mkdir_p 'lib/templates'

        MKDIR

        # Parallel-fix binstubs
        Dir['bin/*'].each do |binstub|
          if File.read(binstub) =~ /load.*spring/
            inject_into_file binstub, <<-PARALLEL, after: /\A.*\n/
running_in_parallel = ENV.has_key?('TEST_ENV_NUMBER') || ARGV.any? { |arg| arg =~ /^parallel:/ }

            PARALLEL

            gsub_file binstub, /^(\s*load .*spring.*)$/, '\1 unless running_in_parallel'
          end
        end
      end

      def setup_guard
        template 'Guardfile'
        environment "config.middleware.use Rack::LiveReload\n", env: :development
        environment "config.assets.digest = false # For Guard::Livereload\n", env: :development
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
        run 'spring stop' # Spring constantly causes trouble here

        generate 'cucumber:install'
        directory 'features/support'
        template 'config/cucumber.yml', force: true

        # Remove cucumber section from database.yml. Don't need this.
        gsub_file 'config/database.yml', /^cucumber.*\z/m, ''

        environment <<~ACTIVE_JOB, env: 'test'
          config.active_job.queue_adapter = :inline
        ACTIVE_JOB
      end

      def install_rspec
        generate 'rspec:install'

        directory 'spec'

        gsub_file '.rspec', "--warnings\n", '' # Don't show Ruby warnings
        template '.rspec_parallel'

        merge_rails_helper_into_spec_helper

        uncomment_lines 'spec/spec_helper.rb', /Dir.Rails.root.join.+spec.support/
        gsub_file 'spec/spec_helper.rb',
          /^  config\.use_transactional_fixtures = true/, <<-CONTENT
  # RSpec's transaction logic needs to be disabled for DatabaseCleaner to work
  config.use_transactional_fixtures = false
        CONTENT
      end

      def install_capistrano
        # Create Capfile *before* installing Capistrano to prevent annoying
        # Harrow.io ad
        template 'Capfile', force: true
        run 'cap install'

        deploy_rb = File.read('config/deploy.rb')
        @version = deploy_rb[/^lock.*?([\d\.]+)/, 1]
        template 'config/deploy.rb', force: true
        template 'config/deploy/staging.rb', force: true
        template 'config/deploy/production.rb', force: true

        directory 'lib/capistrano/tasks'
        template 'lib/tasks/pending_migrations.rake'
      end

      def setup_webpacker
        remove_dir 'app/javascript'
        directory WEBPACK_DIR
        directory 'config/webpack'

        gsub_file 'config/webpacker.yml', /^(  source_path:).*$/, '\1 ' + WEBPACK_DIR
        inject_into_file 'config/webpack/environment.js', <<~JQUERY, after: /\A.*\n/ # 1st line
        const webpack = require('webpack')

        environment.plugins.set('Provide', new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery'
          })
        )
        JQUERY

        yarn :add, *YARN_PACKAGES
      end

      def configure_autoprefixer
        template '.browserslistrc'
      end

      # Bundler prefers installed gems, but we want the newest versions possible
      def update_gems
        run 'bundle install'
      end

      private

      def merge_rails_helper_into_spec_helper
        spec_helper = File.read 'spec/spec_helper.rb'
        spec_helper.gsub! /.*^RSpec\.configure.+?$/m, '' # Remove introduction
        gsub_file 'spec/rails_helper.rb', /end\n\z/, spec_helper

        FileUtils.mv 'spec/rails_helper.rb', 'spec/spec_helper.rb', force: true
      end

    end
  end
end
