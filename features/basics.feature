#@announce-output
#@announce-stderr
Feature: Preparation of a new Rails app (basics generator)

  Scenario: Generate basic files and settings
    Given a pristine Rails application
      And I install katapult

    When I generate katapult basics
    Then the ruby-version file should be up-to-date

    And the file ".gitignore" should contain "config/database.yml"
    And the file "README.md" should contain "# Katapult Test App"
    And the file ".bundle/config" should match /NOKOGIRI.*--use-system-libraries/
    And the file "Guardfile" should contain:
      """
      guard 'livereload' do
        watch %r{app/views/.+\.(erb|haml)$}
        watch 'app/models/power.rb' # Consul
        watch %r{app/helpers/.+\.rb}
        watch %r{config/locales/.+\.yml}
        watch %r{spec/javascripts/} # Jasmine
      end
      """

    And the configured Rails version should be listed in the Gemfile.lock
    And the file "Gemfile" should contain "gem 'katapult', path: '../../..'"
    And a file named "Gemfile.lock" should exist

    And the file "app/controllers/application_controller.rb" should contain:
    """
      before_action :make_action_mailer_use_request_host_and_protocol

      private

      def make_action_mailer_use_request_host_and_protocol
        ActionMailer::Base.default_url_options[:protocol] = request.protocol
        ActionMailer::Base.default_url_options[:host] = request.host_with_port
      end
    """
    And the file "app/mailers/application_mailer.rb" should contain "default from: Rails.configuration.system_email"

    And a file named "public/robots.txt" should exist
    And Turbolinks should be removed
    And the Asset Pipeline should be removed

    But Webpacker should be employed
    And styles should be prepared
    And Unpoly should be installed
    And the file ".browserslistrc" should contain "> 1%"

    And the application layout should be set up
    And the errors controller should be installed

    # Spring
    And the file "config/spring.rb" should contain:
    """
    # Custom generator templates are put into lib/templates
    FileUtils.mkdir_p 'lib/templates'

    %w(
      lib/templates
    """
    And binstubs should be set up


    And the file "app/models/application_record.rb" should contain "def these"
    And the file "app/models/application_record.rb" should contain "def find_by_anything"

    # Config
    And the file "config/application.rb" should contain "config.time_zone = 'Berlin'"
    And the file "config/application.rb" should contain "config.system_email = 'system@katapult_test_app.com'"
    And the file "config/environments/development.rb" should contain "config.assets.debug = false"
    And the file "config/environments/development.rb" should contain "config.assets.digest = false # For Guard::Livereload"
    And the file "config/environments/development.rb" should contain:
      """
        config.middleware.use Rack::LiveReload
      """
    And the file "config/environments/development.rb" should contain:
    """
      config.active_record.migration_error = false
    """
      And the file "config/environments/staging.rb" should contain "require_relative 'production'"
      And the test environment should be configured
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
        username:
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

    And Capistrano should be configured
    And Capistrano should be locked to the installed version

    And initializers should be installed
    And the file "config/initializers/ext.rb" should contain exactly:
    """
    Dir.glob(Rails.root.join('lib/ext/**/*.rb')).sort.each do |filename|
      require filename
    end
    """
    And the file "config/secrets.yml" should contain:
    """
    staging:
      secret_key_base:

    """


    # Lib
    And Katapult templates should have been copied to the application

    And a file "lib/ext/action_view/spec_label.rb" should exist
    And a file "lib/ext/action_view/form_for_with_development_errors.rb" should exist
    And a file "lib/ext/array/xss_aware_join.rb" should exist
    And a file "lib/ext/enumerable/natural_sort.rb" should exist
    And a file "lib/ext/hash/infinite.rb" should exist
    And the file "lib/ext/string/html_entities.rb" should contain "def self.nbsp"
    And the file "lib/ext/string/html_entities.rb" should contain "def self.ndash"
    And a file "lib/ext/string/to_sort_atoms.rb" should exist
    And a file "lib/tasks/pending_migrations.rake" should exist


    # Tests
    And features/support should be prepared
    And spec/support should be prepared
    And a file named "spec/assets/sample.pdf" should exist
    And the file "spec/spec_helper.rb" should contain "  mocks.verify_partial_doubles = true"
    But a file named "spec/rails_helper.rb" should not exist

    And the file "spec/factories/factories.rb" should contain:
    """
    FactoryBot.define do

      factory :EXAMPLE do
        status 'pending'
        uuid { SecureRandom.uuid }
        sequence(:title) { |i| "Titel #{ i }"}
      end

    end
    """
