#@announce-output
#@announce-stderr
Feature: Katapult binary `katapult`

  Scenario: Run without arguments
    When I run `katapult`
    Then the output should contain "Usage: katapult [new APP_NAME | fire [path/to/model] ]"


  Scenario: Missing options are asked for
    When I run `katapult new`
    Then the output should contain "Please enter the application name"

    When I run `katapult new binary_test`
    Then the output should contain "Please enter the database user"

    When I run `katapult new binary_test -u user`
    Then the output should contain "Please enter the database password"

    When I run `katapult new binary_test -u user -p pass`
    Then the output should contain "Please enter the Ruby version for the new project"

    # Note: Rails will refuse to create an application named "test". Calling it
    # "test" here will cancel application creation and speed up this test ;)
    When I run `katapult new test -u user -p pass -r 2.4.1`
    Then the output should contain "Creating new Rails application"


  Scenario: App name gets normalized
    When I run `katapult new TestApp -u user -p pass -r2.4.1`
    Then the output should contain "Creating new Rails application in test_app ..."


  Scenario: Start new Rails application
    Given the default aruba exit timeout is 120 seconds

    When I run `katapult new binary_test` interactively
      And I type "katapult"
      And I type "secret"
      And I type the current Ruby version
    Then the output should contain "Creating new Rails application"
    And the output should contain "Installing katapult"
    And the output should contain "Generating katapult basics"
    And the output should contain the configured Rails version
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

    # test correct insertion of database credentials
    And the file "config/database.yml" should contain "username: katapult"
    And the file "config/database.yml" should contain "password: secret"

#    Not working, probably because Bundler sees an empty BUNDLER_GEMFILE var
#    # test whether the application is already bundled
#    When I run `bundle check`
#    Then the output should contain "The Gemfile's dependencies are satisfied"

    # test whether katapult made git commits
    When I run `git log`
    Then the output should contain "rails new binary_test"
    And the output should contain "rails generate katapult:install"
    And the output should contain "rails generate katapult:basics"
    And the output should contain "Author: katapult <katapult@makandra.com>"


  Scenario: Transform the application model
    Given a new Rails application with Katapult basics installed

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
