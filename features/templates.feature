#@announce-output
#@announce-stderr
Feature: Customizing the templates Katapult uses for code generation

  Background:
    Given a new Rails application with Katapult basics installed


  Scenario: Custom controller template
    When I write to "lib/katapult/application_model.rb" with:
      """
      crud 'Car' do |car|
        car.attr 'name'
      end
      """
    And I write to "lib/templates/katapult/web_ui/controller.rb" with:
      """
      # Custom <%= model_name(:classes) %>Controller template

      """
    And I successfully transform the application model
    Then the file "app/controllers/cars_controller.rb" should contain exactly:
      """
      # Custom CarsController template

      """


  Scenario: Custom view templates
    When I write to "lib/katapult/application_model.rb" with:
      """
      crud 'Car' do |car|
        car.attr 'name'
      end
      """
    And I write to "lib/templates/katapult/views/index.html.haml" with:
      """
      # Custom <%= model_name(:humans) %> list template

      """
    And I write to "lib/templates/katapult/views/_form.html.haml" with:
      """
      # Custom <%= model_name(:human) %> form template

      """
    And I successfully transform the application model
    Then the file "app/views/cars/index.html.haml" should contain exactly:
      """
      # Custom cars list template

      """
    And the file "app/views/cars/_form.html.haml" should contain exactly:
      """
      # Custom car form template

      """


  Scenario: Custom model template
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Car'
      """
    And a file named "lib/templates/katapult/model/model.rb" with:
      """
      # Custom model template for <%= class_name %>

      """
    And I successfully transform the application model
    Then the file "app/models/car.rb" should contain exactly:
      """
      # Custom model template for Car

      """
