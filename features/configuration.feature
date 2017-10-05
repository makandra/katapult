#@announce-output
#@announce-stderr
Feature: Configure katapult

  Background:
    Given a new Rails application with Katapult basics installed


  Scenario: Custom model template
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Car'
      """
    And a file named "lib/templates/katapult/model/model.rb" with:
      """
      # custom model template for <%= class_name %>

      """
    And I successfully transform the application model
    Then the file "app/models/car.rb" should contain exactly:
      """
      # custom model template for Car

      """
