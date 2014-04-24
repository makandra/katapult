Feature: Generate Models

  Background:
    Given a pristine Rails application
      And wheelie is installed


  Scenario: Generate ActiveRecord Model
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.model 'Car'
      end
      """
    And I successfully render the metamodel
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
    And I successfully render the metamodel
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
