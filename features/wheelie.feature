Feature: Wheelie in general

  Scenario: Have Wheelie installed (see Background)
    Given a pristine Rails application
    When I install wheelie
    Then a file named "lib/wheelie/metamodel.rb" should exist

  
  Scenario: Don't render the metamodel if the git working directory is not clean
    Given a pristine Rails application
    And an empty file named "polluting_working_directory"
    And wheelie is installed

    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.model 'Car'
      end
      """
    And I successfully render the metamodel

    Then the output should contain "Wheelie::RenderGenerator::RenderError"
    But the file "app/models/car.rb" should not exist
