Feature: Wheelie binary `wheelie`

  Scenario: Start new Rails application
    When I successfully run `wheelie new binary_test`
    And I cd to "binary_test"

    Then a file named "lib/wheelie/metamodel.rb" should exist
    And a file named "config/database.yml" should exist
    And the file "Gemfile" should contain "gem 'wheelie'"

    When I run `bundle check`
    Then the output should contain "The Gemfile's dependencies are satisfied"


  Scenario: Forget to pass application name
    When I run `wheelie new # without app name`
    Then the output should contain "No value provided for required arguments 'app_path'"


  Scenario: Run without arguments
    When I run `wheelie # without arguments`
    Then the output should contain "Usage: wheelie new APP_NAME"
