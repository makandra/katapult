Feature: Use Wheelie

  Scenario: Generate Model
    Given a pristine Rails application
      And I install wheelie

    When I successfully run `bundle exec rails generate wheelie:model`
    Then a file named "Gemfile" should exist
      And the output should contain "foo"
