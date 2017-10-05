#@announce-output
Feature: Generate Models

  Background:
    Given a pristine Rails application
    And I install katapult
    And I generate katapult basics


  Scenario: Generate ActiveRecord Model
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Car'
      """
    And I successfully transform the application model
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
      class CreateCars < ActiveRecord::Migration[5.1]
        def change
          create_table :cars do |t|

            t.timestamps
          end
        end
      end

      """
    And the file "spec/models/car_spec.rb" should contain exactly:
      """
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
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Person' do |person|

        # Basic types
        person.attr :age, type: :integer
        person.attr :nick, type: :string
        person.attr :hobby # string is default

        # Special types
        person.attr :email # type is auto-detected as email
        person.attr :income, type: :money
        person.attr :homepage, type: :url, default: 'http://www.makandra.de'
        person.attr :locked, type: :flag, default: false
        person.attr :hobbies, type: :text
        person.attr :indexable_json, type: :json
        person.attr :plain_json, type: :plain_json
      end
      """
    And I successfully transform the application model
    Then the file "app/models/person.rb" should contain exactly:
      """
      class Person < ActiveRecord::Base
        include DoesFlag[:locked, default: false]
        has_defaults({:homepage=>"http://www.makandra.de"})

        def to_s
          age.to_s
        end
      end

      """
    And there should be a migration with:
      """
      class CreatePeople < ActiveRecord::Migration[5.1]
        def change
          create_table :people do |t|
            t.integer :age
            t.string :nick
            t.string :hobby
            t.string :email
            t.decimal :income, precision: 10, scale: 2
            t.string :homepage
            t.boolean :locked
            t.text :hobbies
            t.jsonb :indexable_json
            t.json :plain_json

            t.timestamps
          end
        end
      end

      """
    And the file "spec/models/person_spec.rb" should contain exactly:
      """
      describe Person do

        describe '#to_s' do
          it 'returns the #age attribute' do
            subject.age = 778
            expect(subject.to_s).to eql("778")
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

    When I run rspec
    Then the specs should pass


  Scenario: Get a helpful error message when an attribute has an unknown option
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Person' do |person|
        person.attr :x, invalid_option: 'here'
      end
      """
    And I transform the application model
    Then the output should contain "Katapult::Attribute does not support option :invalid_option. (Katapult::Element::UnknownOptionError)"


  Scenario: Specify assignable values
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Person' do |person|
        person.attr :age, type: :integer, assignable_values: 9..99
        person.attr :hobby, assignable_values: %w[soccer baseball], default: 'soccer', allow_blank: true
      end
      """
    And I successfully transform the application model
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
          age.to_s
        end
      end

      """
    And the file "spec/models/person_spec.rb" should contain exactly:
      """
      describe Person do

        describe '#to_s' do
          it 'returns the #age attribute' do
            subject.age = 9
            expect(subject.to_s).to eql("9")
          end
        end

        describe '#age' do
          it { is_expected.to allow_value(99).for(:age) }
          it { is_expected.to_not allow_value(100).for(:age) }
        end

        describe '#hobby' do
          it { is_expected.to allow_value("baseball").for(:hobby) }
          it { is_expected.to_not allow_value("baseball-unassignable").for(:hobby) }

          it 'has a default' do
            expect( subject.hobby ).to eql("soccer")
          end
        end

      end

      """

    When I run rspec
    Then the specs should pass


  Scenario: Transform the application model multiple times

    Do not add routes twice.

    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Car'
      wui 'Car' do |wui|
        wui.crud
      end
      """
      And I successfully transform the application model
    Then the file named "config/routes.rb" should contain:
      """
      Rails.application.routes.draw do
        root 'cars#index'
        resources :cars
      """
      And I successfully transform the application model
    Then the file named "config/routes.rb" should contain:
      """
      Rails.application.routes.draw do
        root 'cars#index'
        resources :cars
      """
      And the file named "config/routes.rb" should contain "root 'cars#index'" exactly once
      And the file named "config/routes.rb" should contain "resources :cars" exactly once
      And the output should contain "Routes for :cars already exist! Not updated."
