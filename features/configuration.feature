Feature: Configure katapult

  Background:
    Given a pristine Rails application
    And I install katapult
    And I generate katapult basics


  Scenario: Custom model template
    When I overwrite "lib/katapult/application_model.rb" with:
      """
      model 'Car'
      """
    And a file named "lib/templates/katapult/model/model.rb" with:
      """
      # custom model template for <%= class_name %>

      """
    And I successfully render the application model
    Then the file "app/models/car.rb" should contain exactly:
      """
      # custom model template for Car

      """
