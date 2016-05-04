Feature: Katapult in general

  Background:
    Given a pristine Rails application


  Scenario: Install katapult
    When I install katapult
    Then the file "lib/katapult/application_model.rb" should contain exactly:
      """
      # Here you define the fundamentals of your application.
      #
      # Add a model:
      # model 'customer' do |customer|
      #   customer.attr :name
      #   customer.attr :birth, type: :date
      #   customer.attr :email
      # end
      #
      # Add a web user interface:
      # wui 'customer' do |wui|
      #   wui.action :index
      #   wui.action :show
      #   wui.action :lock, scope: :member, method: :post
      # end
      #
      # Add navigation
      # navigation :main

      """


  Scenario: Generate basic files and settings
    Given I install katapult

    When I generate katapult basics
    Then the file ".ruby-version" should contain "2.3.0"


    And the file "config/cucumber.yml" should contain:
      """
      default: <%= std_opts %> features
      wip: --tags @wip:3 --wip features
      parallel: <%= std_opts %> features <%= log_failures %>
      rerun: -r features --format pretty --strict <%= rerun_failures %> <%= log_failures %>
      """


      And the file ".gitignore" should contain "config/database.yml"
      And the file ".bundle/config" should match /NOKOGIRI.*--use-system-libraries/
      And the file "Guardfile" should contain:
      """
      guard 'livereload' do
        watch %r{app/views/.+\.(erb|haml)$}
        watch 'app/models/navigation.rb' # Navy
        watch 'app/models/power.rb' # Consul
        watch %r{app/helpers/.+\.rb}
        watch %r{public/.+\.(css|js|html)}
        watch %r{config/locales/.+\.yml}
        watch %r{spec/javascripts/} # Jasmine

        # Rails Assets Pipeline
        watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|sass|js|coffee|html|png|jpg))).*}) do |m|
          filename = m[3]
          # When a .sass (or .css.sass) file was changed, tell the client to load the .css version.
          # Similarly, for .coffee / .js.coffee files we ask the client to reload the .js file.
          filename.gsub! /(\.css)?\.sass$/, '.css'
          filename.gsub! /(\.js)?\.coffee$/, '.js'
          "/assets/#{filename}"
        end
      end
      """
    And the file "Capfile" should contain:
    """
    # Load DSL and set up stages
    require 'capistrano/setup'

    # Include default deployment tasks
    require 'capistrano/deploy'

    # Include tasks from other gems included in your Gemfile
    require 'capistrano/bundler'
    require 'capistrano/maintenance'
    require 'capistrano/rails/assets'
    require 'capistrano/rails/migrations'
    require 'whenever/capistrano'

    Dir.glob('lib/capistrano/tasks/*.rake').each do |r|
      # `import r` calls Rake.application.add_import(r), which imports the file only
      # *after* this file has been processed, so the imported tasks would not be
      # available to the hooks below.
      Rake.load_rakefile r
    end

    before 'deploy:updating', 'db:dump'
    after 'deploy:published', 'deploy:restart'
    after 'deploy:published', 'db:warn_if_pending_migrations'
    after 'deploy:published', 'db:show_dump_usage'
    after 'deploy:finished', 'deploy:cleanup' # https://makandracards.com/makandra/1432
    """
      And the file "Gemfile" should contain "gem 'rails', '4.2.6'"
      And the file "Gemfile" should contain exactly:
      """
      source 'https://rubygems.org'

      gem 'rails', '4.2.6'
      gem 'pg', '~> 0.15'
      gem 'jquery-rails'
      gem 'jbuilder', '~> 2.0'
      gem 'katapult', path: '../../..'

      # internal
      gem 'exception_notification'
      # gem 'admin_cleaner', git: 'git@code.makandra.de:makandra/admin_cleaner.git'

      # security
      gem 'breach-mitigation-rails'
      gem 'safe_cookies'

      # better coding
      gem 'modularity'
      gem 'edge_rider'
      gem 'andand'

      # models
      gem 'has_defaults'
      gem 'assignable_values'

      # gem 'carrierwave'
      # gem 'mini_magick'

      # gem 'spreadsheet'
      # gem 'vcard'

      # views
      # gem 'simple_form'
      # gem 'nested_form'
      gem 'will_paginate'
      gem 'makandra-navy', require: 'navy'

      # assets
      gem 'haml-rails'
      gem 'bootstrap-sass'
      gem 'sass-rails'
      gem 'autoprefixer-rails'
      gem 'coffee-rails'
      gem 'therubyracer', platform: :ruby
      gem 'uglifier'
      gem 'compass-rails'
      gem 'compass-rgbapng'

      group :development do
        gem 'query_diet'
        gem 'better_errors'
        gem 'binding_of_caller'
        gem 'thin'

        gem 'parallel_tests'
        gem 'guard-livereload', require: false
        gem 'rack-livereload'
        gem 'spring-commands-rspec'
        gem 'spring-commands-cucumber'
      end

      group :development, :test do
        gem 'byebug'
        gem 'factory_girl_rails'
        gem 'rspec-rails'
        gem 'spring'
      end

      group :test do
        gem 'database_cleaner'
        gem 'timecop'
        gem 'launchy'

        gem 'capybara'
        gem 'capybara-screenshot'
        gem 'cucumber', '< 2' # Incompatible with Cucumber Factory
        gem 'cucumber-rails', require: false
        gem 'cucumber_factory'
        gem 'selenium-webdriver'
        gem 'spreewald'

        gem 'rspec'
        gem 'shoulda-matchers', require: false
      end

      group :deploy do
        gem 'capistrano-rails', require: false
        gem 'capistrano-bundler', require: false
        gem 'capistrano-maintenance'
      end
      """

    And the file "app/controllers/application_controller.rb" should contain:
    """
      before_filter :make_action_mailer_use_request_host_and_protocol

      private

      def make_action_mailer_use_request_host_and_protocol
        ActionMailer::Base.default_url_options[:protocol] = request.protocol
        ActionMailer::Base.default_url_options[:host] = request.host_with_port
      end
    """

    # Just checking turbolinks was properly removed
    And the file "app/views/layouts/application.html.erb" should not contain "turbolinks"
    But the file "app/views/layouts/application.html.erb" should contain:
    """
      <%= stylesheet_link_tag    'application', media: 'all' %>
      <%= javascript_include_tag 'application' %>
    """



      # Config
    And the file "config/application.rb" should contain "config.time_zone = 'Berlin'"
    And the file "config/environments/development.rb" should contain "config.assets.debug = false"
    And the file "config/environments/development.rb" should contain:
      """
        config.middleware.use Rack::LiveReload
      """
      And a file named "config/environments/staging.rb" should exist
      And the file "config/database.yml" should contain exactly:
      """
      common: &common
        adapter: postgresql
        encoding: unicode
        host: localhost
        username: katapult
        password: secret

      development:
        <<: *common
        database: katapult_test_app_development

      test: &test
        <<: *common
        database: katapult_test_app_test<%= ENV['TEST_ENV_NUMBER'] %>
      """

    And the file "config/database.sample.yml" should contain exactly:
      """
      common: &common
        adapter: postgresql
        encoding: unicode
        host: localhost
        username: root
        password:

      development:
        <<: *common
        database: katapult_test_app_development

      test:
        <<: *common
        database: katapult_test_app_test<%= ENV['TEST_ENV_NUMBER'] %>
      """

    And the file "config/cucumber.yml" should contain:
      """
      default: <%= std_opts %> features
      wip: --tags @wip:3 --wip features
      parallel: <%= std_opts %> features <%= log_failures %>
      rerun: -r features --format pretty --strict <%= rerun_failures %> <%= log_failures %>
      """
    And the file "config/deploy.rb" should contain:
    """
    abort 'You must run this using "bundle exec ..."' unless ENV['BUNDLE_BIN_PATH'] || ENV['BUNDLE_GEMFILE']

    # config valid only for current version of Capistrano
    lock '3.4.0'

    # Default value for :format is :pretty
    # set :format, :pretty

    set :log_level, :info # %i(debug info error), default: :debug

    # Default value for :pty is false
    # set :pty, true

    # Default value for :linked_files is []
    # set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
    set :linked_files, %w(config/database.yml)

    # Default value for linked_dirs is []
    # set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
    set :linked_dirs, %w(log public/system)

    # Default value for default_env is {}
    # set :default_env, { path: "/opt/ruby/bin:$PATH" }

    set :application, 'katapult_test_app'
    set :keep_releases, 10
    set :ssh_options, {
      forward_agent: true
    }
    set :scm, :git
    set :repo_url, 'git@code.makandra.de:makandra/katapult_test_app.git'

    # set :whenever_roles, :cron
    # set :whenever_environment, defer { stage }
    # set :whenever_command, 'bundle exec whenever'

    set :maintenance_template_path, 'public/maintenance.html.erb'
    """
    And the file "config/deploy/staging.rb" should contain:
    """
    set :stage, :staging

    set :deploy_to, '/var/www/katapult_test_app-staging'
    set :rails_env, 'staging'
    set :branch, ENV['DEPLOY_BRANCH'] || 'master'

    # server 'example.com', user: 'deploy-user', roles: %w(app web cron db)
    """
    And the file "config/deploy/production.rb" should contain exactly:
    """
    set :stage, :production

    set :deploy_to, '/var/www/katapult_test_app'
    set :rails_env, 'production'
    set :branch, 'production'

    # server 'one.example.com', user: 'deploy-user', roles: %w(app web cron db)
    # server 'two.example.com', user: 'deploy-user', roles: %w(app web)
    """
    And the file "config/initializers/ext.rb" should contain exactly:
    """
    Dir.glob(Rails.root.join('lib/ext/**/*.rb')).each do |filename|
      require filename
    end
    """
    And the file "config/initializers/exception_notification.rb" should contain:
      """
      ExceptionNotification.configure do |config|

        config.add_notifier :email, {
          email_prefix: '[katapult_test_app] ',
          exception_recipients: %w[fail@makandra.de],
      """
    And the file "config/secrets.yml" should contain:
    """
    staging:
      secret_key_base:

    """


    # Lib
    And the file "lib/capistrano/tasks/db.rake" should contain:
    """
    namespace :db do
      desc 'Warn about pending migrations'
      task :warn_if_pending_migrations do
        on primary :db do
          within current_path do
            with rails_env: fetch(:rails_env, 'production') do
              rake 'db:warn_if_pending_migrations'
            end
          end
        end
      end

      desc 'Do a dump of the DB on the remote machine using dumple'
      task :dump do
        on primary :db do
          within current_path do
            execute :dumple, '--fail-gently', fetch(:rails_env, 'production')
          end
        end
      end

      desc 'Show usage of ~/dumps/ on remote host'
      task :show_dump_usage do
        on primary :db do
          info capture :dumple, '-i'
        end
      end
    end
    """
    And the file "lib/capistrano/tasks/deploy.rake" should contain:
    """
    namespace :deploy do
      desc 'Restart application'
      task :restart do
        invoke 'passenger:restart'
      end

      desc 'Show deployed revision'
      task :revision do
        on roles :app do
          within current_path do
            info "Revision: #{ capture :cat, 'REVISION' }"
          end
        end
      end
    end
    """
    And the file "lib/capistrano/tasks/passenger.rake" should contain:
    """
    namespace :passenger do
      desc 'Restart Application'
      task :restart do
        on roles :app do
          execute "sudo passenger-config restart-app --ignore-app-not-running #{ fetch(:deploy_to) }"
        end
      end
    end
    """
    And the file "lib/ext/active_record/find_by_anything.rb" should contain:
    """
    ActiveRecord::Base.class_eval do

      def self.find_by_anything(identifier)
    """
    And the file "lib/ext/action_view/spec_label.rb" should contain:
    """
    ActionView::Helpers::FormBuilder.class_eval do

      def spec_label(field, text = nil, options = {})
    """
    And the file "lib/ext/action_view/form_for_with_development_errors.rb" should contain:
    """
    if Rails.env == 'development'

      ActionView::Helpers::FormHelper.class_eval do

        def form_for_with_development_errors(*args, &block)
    """
    And the file "lib/ext/active_record/these.rb" should contain:
    """
    ActiveRecord::Base.class_eval do

      def self.these(arg)
        where(id: arg.collect_ids)
      end

    end
    """
    And the file "lib/ext/array/xss_aware_join.rb" should contain:
    """
    Array.class_eval do
      def xss_aware_join(delimiter = '')
        ''.html_safe.tap do |str|
          each_with_index do |element, i|
            str << delimiter if i > 0
            str << element
          end
        end
      end
    end
    """
    And the file "lib/ext/enumerable/natural_sort.rb" should contain:
    """
    module Enumerable

      def natural_sort
    """
    And the file "lib/ext/hash/infinite.rb" should contain:
    """
    class Hash

      def self.infinite
        new { |h, k| h[k] = new(&h.default_proc) }
      end

    end
    """
    And the file "lib/ext/string/html_entities.rb" should contain:
    """
    class String

      def self.nbsp
        ' '
      end

      def self.ndash
        '–'
      end

    end
    """
    And the file "lib/ext/string/to_sort_atoms.rb" should contain:
    """
    String.class_eval do

      def to_sort_atoms
        SmartSortAtom.parse(self)
      end

    end
    """
    And the file "lib/tasks/pending_migrations.rake" should contain:
    """
          pending_migrations = ActiveRecord::Migrator.new(:up, all_migrations).pending_migrations

          if pending_migrations.any?
            puts ''
            puts '======================================================='
            puts "You have #{ pending_migrations.size } pending migrations:"
    """


    # Tests
    And the file "features/support/env-custom.rb" should contain:
      """
      require 'spreewald/all_steps'
      """
    And the file "features/support/cucumber_factory.rb" should contain:
      """
      Cucumber::Factory.add_steps(self)
      """
    And the file "features/support/capybara_screenshot.rb" should contain:
      """
      require 'capybara-screenshot/cucumber'

      # Keep up to the number of screenshots specified in the hash
      Capybara::Screenshot.prune_strategy = { keep: 10 }
      """
    And the file "features/support/database_cleaner.rb" should contain:
      """
      DatabaseCleaner.clean_with(:deletion) # clean once, now
      DatabaseCleaner.strategy = :transaction
      Cucumber::Rails::Database.javascript_strategy = :deletion
      """
    And the file "features/support/factory_girl.rb" should contain:
      """
      World(FactoryGirl::Syntax::Methods)
      """
      And a file named "features/support/paths.rb" should exist
      And a file named "features/support/selectors.rb" should exist
      And the file "spec/rails_helper.rb" should match /^Dir.Rails.root.join.+spec.support/
      And the file "spec/support/shoulda_matchers.rb" should contain:
      """
      require 'shoulda/matchers'

      Shoulda::Matchers.configure do |config|
        config.integrate do |with|
          with.test_framework :rspec
          with.library :rails
        end
      end
      """
      And the file "spec/support/factory_girl.rb" should contain:
      """
      RSpec.configure do |config|
        config.include FactoryGirl::Syntax::Methods
      end
      """
      And the file "spec/factories/factories.rb" should contain:
      """
      FactoryGirl.define do

        factory :EXAMPLE do
          status 'pending'
          uuid { SecureRandom.uuid }
          sequence(:title) { |i| "Titel #{ i }"}
        end

      end
      """



    # styles
    And the file "app/assets/stylesheets/application.sass" should contain:
      """
      @import compass
      @import bootstrap

      @import application/blocks/all

      """
    And the file "app/assets/stylesheets/application/blocks/_all.sass" should contain exactly:
      """
      @import items
      @import layout
      @import navigation
      @import tools

      """
    And a file named "app/assets/stylesheets/application/blocks/_items.sass" should exist
    And a file named "app/assets/stylesheets/application/blocks/_layout.sass" should exist
    And a file named "app/assets/stylesheets/application/blocks/_navigation.sass" should exist
    And a file named "app/assets/stylesheets/application/blocks/_tools.sass" should exist

    # And the file "config/deploy.rb" should contain exactly:
    #   """
    #   stages
    #   """
