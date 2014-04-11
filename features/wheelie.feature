Feature: Use Wheelie

  Background:
    Given a pristine Rails application
      And I install wheelie


  Scenario: Have Wheelie installed (see Background)
    Then a file named "lib/wheelie/metamodel.rb" should exist


  Scenario: Render metamodel
    Then I successfully run `bundle exec rails g wheelie:render`


  Scenario: Generate Model
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Cars' do |cars|
        cars.model 'Car'
      end
      """
      And the metamodel is rendered
    Then a file named "app/models/car.rb" should exist
