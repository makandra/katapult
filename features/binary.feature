Feature: Katapult binary `katapult`

  Scenario: Start new Rails application
    Given The default aruba timeout is 120 seconds

    When I successfully run `katapult target binary_test`
    Then the output should contain "Creating new Rails application"
    And the output should contain "Installing katapult"
    And the output should contain "Generating katapult basics"
    And the output should contain "Done."

    When I cd to "binary_test"
    Then a file named "lib/katapult/application_model.rb" should exist
    And a file named "config/database.yml" should exist
    And the file "Gemfile" should contain "gem 'katapult'"

    When I run `bundle check`
    Then the output should contain "The Gemfile's dependencies are satisfied"


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
