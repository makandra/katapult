#@announce-output
#@announce-stderr
Feature: Katapult in general

  Background:
    Given a pristine Rails application


  Scenario: Generating the application model file
    When I install katapult
    And I generate the application model
    Then the file "lib/katapult/application_model.rb" should contain exactly:
      """
      # Here you define the fundamentals of your application.
      #
      # Add a model:
      # model 'user' do |user|
      #   user.attr :name
      #   user.attr :birth, type: :datetime
      #   user.attr :email
      # end
      #
      # Add a web user interface:
      # wui 'user' do |wui|
      #   wui.crud # Creates all CRUD actions: index, new, show, etc.
      #   wui.action :lock, scope: :member, method: :post
      # end
      #
      # Add main menu
      # navigation :main
      #
      # Add authentication
      # authenticate 'user', system_email: 'system@example.com'

      """


  Scenario: Generate basic files and settings
    Given I install katapult

    When I generate katapult basics
    Then the ruby-version file should be up-to-date

    And the file ".gitignore" should contain "config/database.yml"
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

    And the file "app/controllers/application_controller.rb" should contain:
    """
      before_action :make_action_mailer_use_request_host_and_protocol

      private

      def make_action_mailer_use_request_host_and_protocol
        ActionMailer::Base.default_url_options[:protocol] = request.protocol
        ActionMailer::Base.default_url_options[:host] = request.host_with_port
      end
    """

    And Turbolinks should be removed
    And the Asset Pipeline should be removed

    But Webpacker should be employed
    And styles should be prepared
    And Unpoly should be installed

    And the application layout should be set up

    # Spring
    And the file "config/spring.rb" should contain:
    """
    # Custom generator templates are put into lib/templates
    FileUtils.mkdir_p 'lib/templates'

    %w(
      lib/templates
    """
    And the file "bin/rails" should contain:
    """
    #!/usr/bin/env ruby
    running_in_parallel = ENV.has_key?('TEST_ENV_NUMBER') || ARGV.any? { |arg| arg =~ /^parallel:/ }

    begin
      load File.expand_path('../spring', __FILE__) unless running_in_parallel
    rescue LoadError => e
    """
    And the file "bin/rake" should contain "running_in_parallel ="
    And the file "bin/rspec" should contain "running_in_parallel ="
    And the file "bin/cucumber" should contain "running_in_parallel ="


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
    And the file "config/initializers/ext.rb" should contain exactly:
    """
    Dir.glob(Rails.root.join('lib/ext/**/*.rb')).sort.each do |filename|
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
      ActionView::Helpers::FormHelper.prepend FormForWithErrors
    end
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
      And the file ".rspec" should contain "--require rails_helper"
      And the file ".rspec_parallel" should contain "--require rails_helper"
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
