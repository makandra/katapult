Feature: Wheelie in general

  Background:
    Given a pristine Rails application


  Scenario: Install Wheelie
    When I install wheelie
    Then the file "lib/wheelie/metamodel.rb" should contain exactly:
      """
      metamodel 'kickstart' do |meta|
        # Here you define the fundamentals of your application.
        #
        # Add a model:
        # meta.model 'customer' do |customer|
        #   customer.attr :name
        #   customer.attr :birth, type: date
        #   customer.attr :email
        # end
        #
        # Add a web user interface:
        # meta.wui 'customer' do |wui|
        #   wui.action :index
        #   wui.action :show
        #   wui.action :lock, scope: :member, method: :post
        # end
      end

      """


  Scenario: Generate basic files and settings
    Given I install wheelie
    When I generate wheelie basics
    Then the file "Gemfile" should contain exactly:
      """
      source 'https://rubygems.org'

      # from original Gemfile
      gem 'rails', '4.1.0'
      gem 'mysql2'
      gem 'jquery-rails'
      gem 'jbuilder', '~> 2.0'
      gem 'spring',        group: :development
      gem 'wheelie', path: '../../..'

      # engines
      gem 'haml-rails'

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

      group :assets do
        gem 'sass-rails'
        gem 'coffee-rails'
        gem 'uglifier'
        gem 'compass-rails'
        gem 'compass-rgbapng'
      end

      group :development do
        gem 'query_diet'
        gem 'better_errors'
        gem 'binding_of_caller'
        gem 'thin' # webrick has warnings when used with 1.9

        gem 'guard-livereload', require: false
        gem 'rack-livereload'
        gem 'spring-commands-rspec'
        gem 'spring-commands-cucumber'
      end

      group :development, :test do
        gem 'byebug'
        gem 'factory_girl_rails'
        gem 'rspec-rails'
      end

      group :test do
        gem 'parallel_tests'
        gem 'database_cleaner'
        gem 'timecop'
        gem 'launchy'

        gem 'capybara'
        gem 'cucumber-rails', require: false
        gem 'cucumber_factory'
        gem 'cucumber_spinner'
        gem 'selenium-webdriver'
        gem 'spreewald'

        gem 'rspec_candy'
        gem 'shoulda-matchers', require: false
      end

      """

    And the file "config/database.yml" should contain exactly:
      """
      common: &common
        adapter: mysql2
        encoding: utf8
        username: wheelie
        password: secret

      development:
        <<: *common
        database: wheelie_test_app_development

      test: &test
        <<: *common
        database: wheelie_test_app_test<%= ENV['TEST_ENV_NUMBER'] %>

      cucumber:
        <<: *test
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
        database: wheelie_test_app_development

      test: &test
        <<: *common
        database: wheelie_test_app_test<%= ENV['TEST_ENV_NUMBER'] %>

      cucumber:
        <<: *test

      """

    And the file "features/support/env.rb" should contain:
      """
      require 'rspec_candy/all'
      require 'spreewald/all_steps'
      """
    And a file named "features/support/paths.rb" should exist

    And the file "spec/rails_helper.rb" should contain:
      """
      require 'rspec/rails'
      require 'shoulda/matchers'
      """
    # And the file "config/deploy.rb" should contain exactly:
    #   """
    #   stages
    #   """
