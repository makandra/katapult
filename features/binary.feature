#@announce-output
#@announce-stderr
Feature: Katapult binary `katapult`

  Scenario: Run without arguments
    When I run `katapult`
    Then the output should contain:
    """
    Usage: katapult <command>

    Commands:
    new APP_NAME    Generate a configured Rails application
    enhance         Prepare an existing Rails application for code generation
    fire [PATH]     Transform application model into code
                    Default PATH: lib/katapult/application_model.rb
    version         Print version
    """


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

    This scenario is particularly prone to "Spring zombies". If it fails, make
    sure there are no broken Spring instances (see README).

    # Rails new including yarn install + installing basics takes quite some time
    Given the aruba exit timeout is 90 seconds

    When I successfully run `katapult new binary_test -u katapult -p secret`
    Then the output should contain "Creating new Rails application"
      And the output should contain "Installing Katapult"
      And the output should contain "Generating Katapult basics"

      And the output should contain "Application initialization done."
      And the output should contain "cd binary_test"
      And the output should contain "Model your application in lib/katapult/application_model.rb"
      And the output should contain "Configure public/robots.txt"
      And the output should contain "Write a README"
      And the output should contain "Run `bundle update`"
      And the output should contain "Customize Katapult's template files"

    When I cd to "binary_test"
    Then the file "Gemfile" should contain "gem 'katapult'"
      And the configured Rails version should be listed in the Gemfile.lock
      And a file named "lib/katapult/application_model.rb" should exist
      And Katapult templates should have been copied to the application

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
    Then the output should contain "Loading Katapult"
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
    Then the output should contain "Loading Katapult"
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


  Scenario: Enhancing an existing application
    Given a pristine Rails application
      And the aruba exit timeout is 20 seconds

    When I run `katapult enhance`
    Then the file "Gemfile" should contain "gem 'katapult'"

      And the output should contain "Installing Katapult"
      And the output should contain "Copying template files"

      And the output should contain "Installation of Katapult completed"
      And the output should contain "Customize Katapult's template files"
      And the output should contain "Model your application in lib/katapult/application_model.rb"

      And the file "Gemfile" should contain "gem 'katapult'"
      And a file named "lib/katapult/application_model.rb" should exist
      And Katapult templates should have been copied to the application

    When I run `git log`
      And the output should contain "(before katapult enhance)"
      And the output should contain "Install Katapult"
      And the output should contain "rails generate katapult:templates"
      And the output should contain "Author: katapult <katapult@makandra.com>"


#  @announce-stdout
  Scenario: Enhancing an existing application again

    Enhancing an application that has already been run through Katapult, nothing
    should be overwritten. Instead, Katapult should generate a new application
    model file and leave existing templates untouched.

    Given a pristine Rails application
      And the aruba exit timeout is 20 seconds

    When I run `katapult enhance`
    Then a file named "lib/templates/katapult/views/index.html.haml" should exist

    # Modify files
    When I write to "lib/katapult/application_model.rb" with:
      """
      custom
      """
      And I write to "lib/templates/katapult/views/index.html.haml" with:
      """
      geändert
      """
      And I remove the file "lib/templates/katapult/views/show.html.haml"

    # Enhance again
    When I run `katapult enhance`
    Then the file "lib/katapult/application_model.rb" should contain "custom"
      And a file "lib/katapult/application_model2.rb" should exist

      # Existing template untouched …
      And the file "lib/templates/katapult/views/index.html.haml" should contain "geändert"
      # … but missing template created
      And the file "lib/templates/katapult/views/show.html.haml" should exist
