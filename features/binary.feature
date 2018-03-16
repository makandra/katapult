#@announce-output
#@announce-stderr
Feature: Katapult binary `katapult`

  Scenario: Run without arguments
    When I run `katapult`
    Then the output should contain "Usage: katapult new APP_NAME | fire [path/to/model] | version"


  Scenario: Print versions
    When I run `katapult version`
    Then the output should contain "Katapult"
      And the output should contain "Generating a Rails 5."
      And the output should contain " app on Ruby 2."

    When I run `katapult -v`
    Then the output should contain "Katapult"
      And the output should contain "Generating a Rails 5."
      And the output should contain " app on Ruby 2."


  Scenario: Missing options are asked for
    When I run `katapult new` interactively
      And I type "test_app"
      And I type "katapult"
      And I type "secret"
    Then the output should contain "Creating new Rails application"

    # Aruba seemingly cannot test output interleaved with input, so the output
    # is tested after exiting the script
    When I stop the command above
    Then the output should contain "Please enter the database user"
    Then the output should contain "Please enter the application name"
    Then the output should contain "Please enter the database password"


  Scenario: App name gets normalized
    When I run `katapult new TestApp --verbose`
    Then the output should contain "Normalized application name: test_app"


#  @announce-output
  Scenario: Start new Rails application
    # Rails new including yarn install + installing basics takes quite some time
    Given the aruba exit timeout is 90 seconds

    When I successfully run `katapult new binary_test -u katapult -p secret`
    Then the output should contain "Creating new Rails application"
      And the output should contain "Installing katapult"
      And the output should contain "Generating katapult basics"

      And the output should contain "Application initialization done."
      And the output should contain "Model your application in lib/katapult/application_model.rb"
      And the output should contain "Configure public/robots.txt"
      And the output should contain "Write a README"
      And the output should contain "Run `bundle update`"

    When I cd to "binary_test"
    Then the file "Gemfile" should contain "gem 'katapult'"
      And the configured Rails version should be listed in the Gemfile.lock
      And a file named "lib/katapult/application_model.rb" should exist

      And the file "config/database.yml" should contain "username: katapult"
      And the file "config/database.yml" should contain "password: secret"

    When I run `bundle check`
    Then the output should contain "The Gemfile's dependencies are satisfied"

    When I run `git log`
    Then the output should contain "rails new binary_test"
      And the output should contain "rails generate katapult:app_model"
      And the output should contain "rails generate katapult:basics"
      And the output should contain "Author: katapult <katapult@makandra.com>"


  Scenario: Transform the default application model
    Given a new Rails application with Katapult basics installed
      And the default aruba exit timeout is 45 seconds

    When I generate the application model
      And I run `katapult fire`
    Then the output should contain "Loading katapult"
    And the output should contain "parse  lib/katapult/application_model"
    And the output should contain "render  into katapult_test_app"

    And the output should contain:
    """
    Model transformation done.

    Now boot up your development server (e.g. with `rails server`) and try your
    kickstarted application in the browser!
    """

    When I run `git log`
    Then the output should contain "rails generate katapult:transform lib/katapult/application_model.rb"
      And the output should contain "Author: katapult <katapult@makandra.com>"


  Scenario: Transform a custom application model
    Given a new Rails application with Katapult basics installed

    When I write to "lib/katapult/custom_model.rb" with:
    """
    model 'custom'
    """
    And I run `katapult fire lib/katapult/custom_model.rb`
    Then the output should contain "Loading katapult"
    And the output should contain "parse  lib/katapult/custom_model"
    And a file named "app/models/custom.rb" should exist


  Scenario: When the transformation fails, an error message is printed
    Given a new Rails application with Katapult basics installed

    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'failing example' do |ex|
        ex.attr :fail, type: :nonexistent
      end
      """
    And I run `katapult fire`
    Then the output should not contain "Model transformation done"
    But the output should contain "x Something went wrong"
