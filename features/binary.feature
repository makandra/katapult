Feature: Wheelie binary `wheelie`

  Scenario: Start new Rails application
    Given The default aruba timeout is 120 seconds

    When I successfully run `wheelie target binary_test`
    And I cd to "binary_test"

    Then a file named "lib/wheelie/application_model.rb" should exist
    And a file named "config/database.yml" should exist
    And the file "Gemfile" should contain "gem 'wheelie'"

    When I run `bundle check`
    Then the output should contain "The Gemfile's dependencies are satisfied"


  Scenario: Forget to pass application name
    When I run `wheelie target # without app name`
    Then the output should contain "No value provided for required arguments 'app_path'"


  Scenario: Run without arguments
    When I run `wheelie # without arguments`
    Then the output should contain "Usage: wheelie [target APP_NAME | render]"
