Feature: Generate Models

  Background:
    Given a pristine Rails application
    And I install wheelie
    And I generate wheelie basics


  Scenario: Generate ActiveRecord Model
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      model 'Car'
      """
    And I successfully render the metamodel
    Then the file "app/models/car.rb" should contain exactly:
      """
      class Car < ActiveRecord::Base

        def to_s
          "Car##{id}"
        end
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
    And the file "spec/models/car_spec.rb" should contain exactly:
      """
      require 'rails_helper'

      describe Car do

        describe '#to_s' do
          it 'returns its class name with its id' do
            subject.id = 17
            expect(subject.to_s).to eql("Car#17")
          end
        end

      end

      """


  Scenario: Generate ActiveRecord Model with attributes
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      model 'Person' do |person|

        # Basic types
        person.attr :age, type: :integer
        person.attr :nick, type: :string
        person.attr :hobby # string is default

        # Special types
        person.attr :email # type is detected as email
        person.attr :income, type: :money
        person.attr :homepage, type: :url, default: 'http://www.makandra.de'
        person.attr :locked, type: :flag, default: false
      end
      """
    And I successfully render the metamodel
    Then the file "app/models/person.rb" should contain exactly:
      """
      class Person < ActiveRecord::Base
        has_defaults({:homepage=>"http://www.makandra.de"})
        include DoesFlag[:locked, default: false]

        def to_s
          "Person##{id}"
        end
      end

      """
    And there should be a migration with:
      """
      class CreatePeople < ActiveRecord::Migration
        def change
          create_table :people do |t|
            t.integer :age
            t.string :nick
            t.string :hobby
            t.string :email
            t.decimal :income, precision: 10, scale: 2
            t.string :homepage
            t.boolean :locked

            t.timestamps
          end
        end
      end

      """
    And the file "spec/models/person_spec.rb" should contain exactly:
      """
      require 'rails_helper'

      describe Person do

        describe '#to_s' do
          it 'returns its class name with its id' do
            subject.id = 17
            expect(subject.to_s).to eql("Person#17")
          end
        end

        describe '#homepage' do

          it 'has a default' do
            expect( subject.homepage ).to eql("http://www.makandra.de")
          end
        end

        describe '#locked' do

          it 'has a default' do
            expect( subject.locked ).to eql(false)
          end
        end

      end

      """
    And the specs should pass


  Scenario: Generate ActiveRecord Model with label attribute
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      model 'Person' do |person|
        person.attr :name
        person.label_attr = :name
      end
      """
    And I successfully render the metamodel
    Then the file "app/models/person.rb" should contain exactly:
      """
      class Person < ActiveRecord::Base

        def to_s
          name.to_s
        end
      end

      """
    And the file "spec/models/person_spec.rb" should contain exactly:
      """
      require 'rails_helper'

      describe Person do

        describe '#to_s' do
          it 'returns the #name attribute' do
            subject.name = "name-string"
            expect(subject.to_s).to eql("name-string")
          end
        end

      end

      """
    And the specs should pass


  Scenario: Get a helpful error message when an attribute has an unknown option
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      model 'Person' do |person|
        person.attr :x, invalid_option: 'here'
      end
      """
    And I render the metamodel
    Then the output should contain "Wheelie::Attribute does not support option :invalid_option. (Wheelie::Element::UnknownOptionError)"


  Scenario: Specify assignable_values
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      model 'Person' do |person|
        person.attr :hobby, assignable_values: %w[soccer baseball], default: 'soccer', allow_blank: true
        person.attr :age, assignable_values: 9..99
      end
      """
    And I successfully render the metamodel
    Then the file "app/models/person.rb" should contain exactly:
      """
      class Person < ActiveRecord::Base
        assignable_values_for :age, {} do
          9..99
        end
        assignable_values_for :hobby, {:allow_blank=>true, :default=>"soccer"} do
          ["soccer", "baseball"]
        end

        def to_s
          "Person##{id}"
        end
      end

      """
    And the file "spec/models/person_spec.rb" should contain exactly:
      """
      require 'rails_helper'

      describe Person do

        describe '#to_s' do
          it 'returns its class name with its id' do
            subject.id = 17
            expect(subject.to_s).to eql("Person#17")
          end
        end

        describe '#hobby' do
          it { is_expected.to allow_value("baseball").for(:hobby) }
          it { is_expected.to_not allow_value("baseball-unassignable").for(:hobby) }

          it 'has a default' do
            expect( subject.hobby ).to eql("soccer")
          end
        end

        describe '#age' do
          it { is_expected.to allow_value(99).for(:age) }
          it { is_expected.to_not allow_value(100).for(:age) }
        end

      end

      """
    And the specs should pass
