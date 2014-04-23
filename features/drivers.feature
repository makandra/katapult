Feature: Drivers

  A driver renders a metamodel. The default driver is "makandra", however, it
  may be customized by copying it into the Rails app.

  Background:
    Given a pristine Rails application
      And I install wheelie


  Scenario: Customize driver (here: have :integer as default attribute type)
    Given I copy the "makandra" driver to "integer_driver"
    And I overwrite "lib/wheelie/drivers/integer_driver/model.rb" with:
      """
      module Wheelie
        class Driver
          module IntegerDriver
            class Model

              def initialize(name)
                @name = name
                @string_attrs = []
              end

              def attr(name, options = {})
                @string_attrs << name.to_s
              end

              def render
                params = [@name]
                @string_attrs.each do |attr|
                  params << (attr + ':integer')
                end

                Rails::Generators.invoke('model', params)
              end

            end
          end
        end
      end

      """
    And I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.model 'Car' do |car|
          car.attr :brand, type: :string
          car.attr :owner, type: :string
        end
      end
      """
    When the metamodel is rendered driven by "integer_driver"
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