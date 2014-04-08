Feature: Use Wheelie

  Scenario: Generate Model
    Given a pristine Rails application
      And a file named "lib/wheelie/metamodel.rb" with:
      """
      Wheelie.metamodel 'CRM' do
        
        model 'User' do
        end

      end
      """
    When I successfully run `rake wheelie:generate`
    Then a file named "Gemfile" should exist
