#@announce-output
#@announce-stderr
Feature: Generate Models

  Background:
    Given a new Rails application with Katapult basics installed


  Scenario: Generate ActiveRecord Model
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Car'
      """
    And I successfully transform the application model
    Then the file "app/models/car.rb" should contain exactly:
      """
      class Car < ApplicationRecord


        def to_s
          "Car##{id}"
        end

      end

      """
    And there should be a migration with:
      """
      class CreateCars < ActiveRecord::Migration[5.2]
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
            expect(subject.to_s).to eq("Car#17")
          end
        end

      end

      """
    And the file "spec/factories/factories.rb" should contain:
      """
        factory :car
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
    And I successfully transform the application model including migrations
    Then the file "app/models/person.rb" should contain exactly:
      """
      class Person < ApplicationRecord

        include DoesFlag[:locked, default: false]

        has_defaults({:homepage=>"http://www.makandra.de"})

        def to_s
          age.to_s
        end

      end

      """
    And there should be a migration with:
      """
      class CreatePeople < ActiveRecord::Migration[5.2]
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
            expect(subject.to_s).to eq("778")
          end
        end

        describe '#homepage' do

          it 'has a default' do
            expect(subject.homepage).to eq("http://www.makandra.de")
          end
        end

        describe '#locked' do

          it 'has a default' do
            expect(subject.locked).to eq(false)
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


  Scenario: Specify model associations
    When I write to "lib/katapult/application_model.rb" with:
      """
      # Associations can use models that are defined below
      model 'User' do |user|
        user.belongs_to 'Company'
      end

      model('Company') { |c| c.attr :name }
      model 'Note' do |note|
        note.belongs_to :owner, polymorphic: %w[Company User]
      end
      model 'Employee' do |employee|
        employee.belongs_to :employer, model: 'Company'
      end
      """
      And I successfully transform the application model including migrations

    Then the file "app/models/company.rb" should contain "has_many :users"
      And the file "app/models/company.rb" should contain "has_many :notes"
      And the file "app/models/company.rb" should contain "has_many :employees"

      And the file "app/models/user.rb" should contain "has_many :notes"
      And the file "app/models/user.rb" should contain "belongs_to :company"
      And the file "app/models/user.rb" should contain:
      """
        assignable_values_for :company, {:allow_blank=>true} do
          Company.all.to_a
        end
      """
      And there should be a migration with:
      """
          create_table :users do |t|
            t.integer :company_id
      """

      And the file "app/models/note.rb" should contain "belong_to :owner, polymorphic: true"

      And the file "app/models/employee.rb" should contain "belongs_to :employer, class_name: 'Company'"


  Scenario: Specify assignable values
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Person' do |person|
        person.attr :age, type: :integer, assignable_values: 9..99
        person.attr :mood, assignable_values: %w[happy pensive]
        person.attr :hobby, assignable_values: %w[soccer baseball], default: 'soccer', allow_blank: true
      end
      """
    And I successfully transform the application model including migrations
    Then the file "app/models/person.rb" should contain:
      """
        assignable_values_for :age, {} do
          9..99
        end

        assignable_values_for :mood, {} do
          ["happy", "pensive"]
        end

        assignable_values_for :hobby, {:allow_blank=>true, :default=>"soccer"} do
          ["soccer", "baseball"]
        end

        def to_s
          age.to_s
        end
      """
    And the file "spec/models/person_spec.rb" should contain:
      """
        describe '#age' do
          it { is_expected.to allow_value(99).for(:age) }
          it { is_expected.to_not allow_value(100).for(:age) }
        end

        describe '#mood' do
          it { is_expected.to allow_value("pensive").for(:mood) }
          it { is_expected.to_not allow_value("pensive-unassignable").for(:mood) }
        end

        describe '#hobby' do
          it { is_expected.to allow_value("baseball").for(:hobby) }
          it { is_expected.to_not allow_value("baseball-unassignable").for(:hobby) }

          it 'has a default' do
            expect(subject.hobby).to eq("soccer")
          end
        end
      """
      And the file "spec/factories/factories.rb" should contain:
      """
        factory :person do
          age 9
          mood "happy"
        end
      """

    When I write to "spec/models/factory_spec.rb" with:
      """
      describe Person do

        describe 'person factory' do
          subject { create :person }

          it 'generates a valid record' do
            expect(subject).to be_valid
          end
        end

      end
      """
      And I run rspec
    Then the specs should pass


  Scenario: Transform the application model multiple times

    Some generators inject code snippets into files. They should not do this
    if their snippet is already present.

    When I write to "lib/katapult/application_model.rb" with:
      """
      crud('Car') { |c| c.attr :model }
      """
      And I successfully transform the application model
    Then the file named "config/routes.rb" should contain:
      """
      Rails.application.routes.draw do
        root 'cars#index'
        resources :cars
      """

    When I successfully transform the application model
    Then the file named "config/routes.rb" should contain:
      """
      Rails.application.routes.draw do
        root 'cars#index'
        resources :cars
      """
      And the file named "config/routes.rb" should contain "root 'cars#index'" exactly once
      And the file named "config/routes.rb" should contain "resources :cars" exactly once
      And the output should contain "Routes for :cars already exist! Not updated."

      And the file named "spec/factories/factories.rb" should contain "factory :car" exactly once
