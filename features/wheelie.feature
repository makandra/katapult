Feature: Wheelie in general

  Scenario: Have Wheelie installed (see Background)
    Given a pristine Rails application with wheelie installed
    Then a file named "lib/wheelie/metamodel.rb" should exist
