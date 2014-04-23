Feature: Use Wheelie

  Background:
    Given a pristine Rails application
      And I install wheelie


  Scenario: Have Wheelie installed (see Background)
    Then a file named "lib/wheelie/metamodel.rb" should exist

  
  # ich glaub dieses Szenario ist sinnlos, da der Befehl niemals failen kann
  Scenario: Render metamodel
    Then I successfully run `bundle exec rails g wheelie:render`


  Scenario: Generate ActiveRecord Model
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.model 'Car'
      end
      """
    And the metamodel is rendered
    Then the file "app/models/car.rb" should contain exactly:
      """
      class Car < ActiveRecord::Base
      end

      """
    And there should be a migration with:
      """
      class CreateCars < ActiveRecord::Migration
        def change
          create_table :cars do |t|

            t.timestamps
          end
        end
      end

      """


  Scenario: Generate ActiveRecord Model with attributes
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.model 'Car' do |car|
          car.attr :brand, type: :string
          car.attr :owner # :string is default
        end
      end
      """
      And the metamodel is rendered
    Then the file "app/models/car.rb" should contain exactly:
      """
      class Car < ActiveRecord::Base
      end

      """
    And there should be a migration with:
      """
      class CreateCars < ActiveRecord::Migration
        def change
          create_table :cars do |t|
            t.string :brand
            t.string :owner

            t.timestamps
          end
        end
      end

      """

  Scenario: Customize driver
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