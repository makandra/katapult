Feature: Katapult binary `katapult`

  Scenario: Start new Rails application
    Given the default aruba timeout is 120 seconds

    When I successfully run `katapult target binary_test`
    Then the output should contain "Creating new Rails application"
    And the output should contain "Installing katapult"
    And the output should contain "Generating katapult basics"
    And the output should contain:
    """
    Application initialization done.

    Next step: Model your application in lib/katapult/application_model.rb and
    transform it into code by running `katapult fire`.
    """

    When I cd to "binary_test"

    # test whether katapult is installed
    Then the file "Gemfile" should contain "gem 'katapult'"
    And a file named "lib/katapult/application_model.rb" should exist

    # test whether the application is already bundled
    When I run `bundle check`
    Then the output should contain "The Gemfile's dependencies are satisfied"

    # test whether katapult made git commits
    When I run `git log`
    Then the output should contain "rails new binary_test"
    And the output should contain "rails generate katapult:install"
    And the output should contain "rails generate katapult:basics"
    And the output should contain "Author: katapult <katapult@makandra.com>"


  Scenario: Forget to pass application name
    When I run `katapult target # without app name`
    Then the output should contain "No value provided for required arguments 'app_path'"


  Scenario: Run without arguments
    When I run `katapult # without arguments`
    Then the output should contain "Usage: katapult [target APP_NAME | fire]"


  Scenario: Transform the application model
    Given a pristine Rails application
    And I install katapult
    And I generate katapult basics

    When I run `katapult fire`
    Then the output should contain "Loading katapult"
    And the output should contain "parse  lib/katapult/application_model"
    And the output should contain "render  into katapult_test_app"

    And the output should contain:
    """
    Model transformation done.

    Now boot up your development server (e.g. with `rails server`) and try your
    kickstarted application in the browser!
    """
