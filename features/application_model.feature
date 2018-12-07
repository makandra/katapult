#@announce-output
Feature: The default application model prepared by Katapult

  Scenario: Generating the application model template
    Given a new Rails application with Katapult basics installed

    When I generate the application model
    Then the file "lib/katapult/application_model.rb" should contain "crud 'product'"
      And the file "lib/katapult/application_model.rb" should contain "product.attr :price, type: :money"
      And the file "lib/katapult/application_model.rb" should contain "product.belongs_to 'user'"

      And the file "lib/katapult/application_model.rb" should contain "model 'user'"
      And the file "lib/katapult/application_model.rb" should contain "web_ui 'user'"
      And the file "lib/katapult/application_model.rb" should contain "navigation"
      And the file "lib/katapult/application_model.rb" should contain "authenticate 'user'"

    When I successfully transform the application model including migrations
      And I run cucumber
    Then the features should pass

    When I run rspec
    Then the specs should pass


  Scenario: Generating a second application model

    An existing application model should not be overwritten.

    Given a new Rails application with Katapult basics installed

    When I generate the application model
    Then the file "lib/katapult/application_model.rb" should exist

    When I generate the application model
    Then a file "lib/katapult/application_model2.rb" should exist

    Given a file "lib/katapult/application_model42.rb" with "many"
    When I generate the application model
    Then a file "lib/katapult/application_model43.rb" should exist
