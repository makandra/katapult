Feature: Drivers

  A driver renders a metamodel. The default driver is "makandra", however, it
  may be customized by copying it into the Rails app.

  Background:
    Given a pristine Rails application
      And I install wheelie


  Scenario: Customize driver (here: have :integer as default attribute type)
    Given I copy the "makandra" driver to "integer_attribute_driver"
    And I replace "attr + ':string'" with "attr + ':integer'" inside "lib/wheelie/drivers/integer_attribute_driver/model.rb"
    And I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.model 'Car' do |car|
          car.attr :brand
          car.attr :owner
        end
      end
      """
    When the metamodel is rendered driven by "integer_attribute_driver"
    Then there should be a migration with:
        """
        class CreateCars < ActiveRecord::Migration
          def change
            create_table :cars do |t|
              t.integer :brand
              t.integer :owner

              t.timestamps
            end
          end
        end

        """