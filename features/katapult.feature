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
      And the file "Gemfile" should contain "gem 'rails', '4.2.4'"
      And the file "Gemfile" should contain exactly:
      """
      source 'https://rubygems.org'

      # from original Gemfile
      gem 'rails', '4.2.4'
      gem 'jquery-rails'
      gem 'jbuilder', '~> 2.0'
      gem 'katapult', path: '../../..'

      # engines
      gem 'haml-rails'
      gem 'mysql2', '~> 0.3.18' # Work around require-error in Rails 4.2

      # internal
      gem 'exception_notification'
      gem 'breach-mitigation-rails'

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
      gem 'bootstrap-sass'
      gem 'sass-rails'
      gem 'autoprefixer-rails'
      gem 'coffee-rails'
      gem 'uglifier'
      gem 'compass-rails', '>= 2.0.4' # fixes "uninitialized constant Sprockets::SassCacheStore"
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
        gem 'cucumber-rails', require: false
        gem 'cucumber_factory'
        gem 'selenium-webdriver'
        gem 'spreewald'

        gem 'rspec'
        gem 'shoulda-matchers', require: false
      end

      """



      # Config
      And the file "config/application.rb" should contain "config.time_zone = 'Berlin'"
      And the file "config/database.yml" should contain exactly:
      """
      common: &common
        adapter: mysql2
        encoding: utf8
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
        adapter: mysql2
        encoding: utf8
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
    And the file "config/initializers/find_by_anything.rb" should contain:
      """
      ActiveRecord::Base.class_eval do

        def self.find_by_anything(identifier)
      """
    And the file "config/initializers/exception_notification.rb" should contain:
      """
      ExceptionNotification.configure do |config|

        config.add_notifier :email, {
          email_prefix: '[katapult_test_app] ',
          exception_recipients: %w[fail@makandra.de],
      """
    And the file "config/initializers/form_for_with_development_errors.rb" should contain:
      """
      if Rails.env == 'development'

        ActionView::Helpers::FormHelper.class_eval do

          def form_for_with_development_errors(*args, &block)
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
