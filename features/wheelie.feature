Feature: Use Wheelie

  Background:
    Given a pristine Rails application
      And I install wheelie


  Scenario: Have Wheelie installed (see Background)
    Then a file named "lib/wheelie/metamodel.rb" should exist
      And a file named "lib/tasks/wheelie.rake" should exist


  # Scenario: Generate Model
  #   When I overwrite "lib/wheelie/metamodel.rb" with:
  #     """
  #     # foo
  #     """
  #     And I successfully run `bundle exec rails generate wheelie:model`
  #   Then a file named "Gemfile" should exist
  #     And the output should contain "foo"
