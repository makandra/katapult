Feature: Configure Wheelie

  Background:
    Given a pristine Rails application
    And I install wheelie
    And I generate wheelie basics


  Scenario: Custom model template
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      model 'Car'
      """
    And a file named "lib/templates/wheelie/model/model.rb" with:
      """
      # custom model template for <%= class_name %>

      """
    And I successfully render the metamodel
    Then the file "app/models/car.rb" should contain exactly:
      """
      # custom model template for Car

      """
