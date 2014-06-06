@announce
Feature: Web User Interface

  Background:
    Given a pristine Rails application with wheelie installed


  Scenario: Generate a basic Web User Interface
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.wui 'Car'
      end
      """
    And I successfully render the metamodel
    Then the file "app/controllers/cars_controller.rb" should contain exactly:
      """
      class CarsController < ApplicationController

      end

      """
    And the file "config/routes.rb" should contain:
      """
        resources :cars, only: [] do
          member do
          end
          collection do
          end
        end
      """


  Scenario: Generate a Web User Interface with actions
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        test.wui 'Car' do |wui|
          wui.action :index
          wui.action :show
          wui.action :create
          wui.action :update
          wui.action :destroy
          wui.action :custom_action, method: :post, scope: :member
          wui.action :other_action, method: :get, scope: :collection
        end
      end
      """
    And I successfully render the metamodel
    Then the file "app/controllers/cars_controller.rb" should contain exactly:
      """
      class CarsController < ApplicationController

        def index
        end

        def show
        end

        def new
        end

        def create
        end

        def edit
        end

        def update
        end

        def destroy
        end

        def custom_action
        end

        def other_action
        end

      end

      """
    And the file "config/routes.rb" should contain:
      """
        resources :cars, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
          member do
            post 'custom_action'
          end
          collection do
            get 'other_action'
          end
        end
      """
    And a file named "app/views/cars/index.html.haml" should exist
    And a file named "app/views/cars/show.html.haml" should exist
    And a file named "app/views/cars/new.html.haml" should exist
    And a file named "app/views/cars/edit.html.haml" should exist
    And a file named "app/views/cars/_form.html.haml" should exist
    And a file named "app/views/cars/custom_action.html.haml" should exist
    And a file named "app/views/cars/other_action.html.haml" should exist


  Scenario: Generate a Web User Interface connected to a model
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        model 'Car' do |car|
          car.attr :brand, type: :string
        end

        test.wui 'Car', model: 'Car' do |wui|
          wui.action :index
          wui.action :show
          wui.action :create
          wui.action :update
          wui.action :destroy
          wui.action :member_action, method: :post, scope: :member
          wui.action :collection_action, method: :get, scope: :collection
        end
      end
      """
    And I successfully render the metamodel
    Then the file "app/controllers/cars_controller.rb" should contain exactly:
      """
      class CarsController < ApplicationController

        def index
          load_collection
        end

        def show
          load_object
        end

        def new
          build_object
        end

        def create
          build_object
        end

        def edit
          load_object
        end

        def update
          load_object
        end

        def destroy
          load_object
        end

        def member_action
          load_object
        end

        def collection_action
          load_collection
        end

        private

        def build_object
          @object ||= Car.build
          @object.attributes = params[:car]
        end

        def load_object
          @object ||= Car.find(params[:id])
        end

        def load_collection
          @collection ||= Car.all
        end

      end

      """
    And the file "app/views/cars/index.html.haml" should contain exactly:
      """
      .title
        Cars

      .tools
        = link_to 'Add car', new_car_path, class: 'button'

      %table.items
        - @collection.each do |car|
          %tr
            %td
              = link_to car.to_s, car_path(car), class: 'hyperlink'
            %td.items__actions
              = link_to 'Edit', edit_car_path(car), class: 'items__action'
              = link_to 'Destroy', car_path(car), method: :delete, class: 'items__action', confirm: 'Really destroy?'

      """
    And the file "app/views/cars/show.html.haml" should contain exactly:
      """
      .title
        = @object.to_s

      .tools
        = link_to 'All cars', cars_path, class: 'button'
        = link_to 'Edit', edit_car_path(@object), class: 'button is_primary'
        = link_to 'Destroy', car_path(@object), method: :delete, class: 'button', confirm: 'Really destroy?'

      %dl.values
        %dt
          = Car.human_attribute_name(:brand)
        %dd
          = @object.brand

      """
    And the file "app/views/cars/new.html.haml" should contain exactly:
      """
      .title
        Add car

      = render 'form'

      """
    And the file "app/views/cars/edit.html.haml" should contain exactly:
      """
      .title
        = @object.to_s

      = render 'form'

      """
    And the file "app/views/cars/_form.html.haml" should contain exactly:
      """
      = form_for @object do |form|

        .tools
          = button_tag 'Save', class: 'button is_primary'
          - cancel_path = @object.new_record? ? cars_path : car_path(@object)
          = link_to 'Cancel', cancel_path, class: 'button'

        %dl.controls
          %dt
            = form.label :brand
          %dd
            = form.text_field :brand

      """
    And the file "app/views/cars/member_action.html.haml" should contain exactly:
      """
      .title
        Member Action

      .tools
        = link_to 'All cars', cars_path, class: 'button'

      """
    And the file "app/views/cars/collection_action.html.haml" should contain exactly:
      """
      .title
        Collection Action

      """
