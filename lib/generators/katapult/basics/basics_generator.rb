# Generates model-independent application basics (see method names).

require 'katapult/generator_goodies'

module Katapult
  module Generators
    class BasicsGenerator < Rails::Generators::Base
      include Katapult::GeneratorGoodies

      desc 'Generate basics like test directories and gems'
      source_root File.expand_path('../templates', __FILE__)

      class_option :db_user, type: :string, default: '',
        description: 'The user to set in config/database.yml'
      class_option :db_password, type: :string, default: '',
        description: 'The password to set in config/database.yml'


      def add_gitignore
        template '.gitignore', force: true
      end

      def write_ruby_version
        template '.ruby-version'
      end

      def write_database_ymls
        @db_user = options.db_user
        @db_password = options.db_password

        template 'config/database.yml', force: true
        template 'config/database.sample.yml'
      end

      def enhance_gemfile
        # Need to transfer the katapult line, because in tests, katapult is
        # installed with a custom :path option
        @katapult = File.readlines('Gemfile').find{ |line| line =~ /^gem 'katapult'/ }
        template 'Gemfile', force: true
      end

      def bundle_install
        run 'bundle install'

        # This is relevant for the server, so it may happen after bundling here.
        # By having Nokogiri use system libraries, it will get automatic updates
        # of the frequently broken libxml (i.e. when the system libxml updates).
        run 'bundle config --local build.nokogiri --use-system-libraries'
      end

      def remove_turbolinks_js
        gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''
        gsub_file 'app/views/layouts/application.html.erb', ", 'data-turbolinks-track': 'reload'", ''
      end

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

      def disable_migration_errors
        development = 'config/environments/development.rb'
        gsub_file development, /(migration_error =) :page_load/, '\1 false'
      end

      def setup_staging
        template 'config/environments/staging.rb'

        # Cheating in the "staging" secret between "test" and "production"
        secret = run('rake secret', capture: true).chomp
        insert_into_file 'config/secrets.yml', <<~SECRET, after: "test:\n"
          secret_key_base: #{ secret }

        staging:
        SECRET
      end

      def create_databases
        run 'rake db:drop db:create parallel:drop parallel:create'
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

      def install_initializers
        directory 'config/initializers'
      end

      def install_ext
        directory 'lib/ext'
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

        environment <<~ACTIVE_JOB, env: 'test'
          config.active_job.queue_adapter = :inline
        ACTIVE_JOB
      end

      def install_rspec
        generate 'rspec:install'

        gsub_file '.rspec', "--warnings\n", '' # Don't show Ruby warnings
        gsub_file '.rspec', '--require spec_helper', '--require rails_helper'
        template '.rspec_parallel'

        uncomment_lines 'spec/rails_helper.rb', /Dir.Rails.root.join.+spec.support/
        template 'spec/support/shoulda_matchers.rb'
        template 'spec/support/factory_girl.rb'
        directory 'spec/factories'
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

      def install_styles
        remove_file 'app/assets/stylesheets/application.css'
        directory 'app/assets/stylesheets', force: true
      end

    end
  end
end
