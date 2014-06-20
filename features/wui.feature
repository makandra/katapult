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
          wui.action :get_member, method: :get, scope: :member
          wui.action :post_member, method: :post, scope: :member
          wui.action :get_collection, method: :get, scope: :collection
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

        def get_member
        end

        def post_member
        end

        def get_collection
        end

      end

      """
    And the file "config/routes.rb" should contain:
      """
        resources :cars, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
          member do
            get 'get_member'
            post 'post_member'
          end
          collection do
            get 'get_collection'
          end
        end
      """
    And a file named "app/views/cars/index.html.haml" should exist
    And a file named "app/views/cars/show.html.haml" should exist
    And a file named "app/views/cars/new.html.haml" should exist
    And a file named "app/views/cars/edit.html.haml" should exist
    And a file named "app/views/cars/_form.html.haml" should exist
    And a file named "app/views/cars/get_member.html.haml" should exist
    And a file named "app/views/cars/get_collection.html.haml" should exist
    But a file named "app/views/cars/post_member.html.haml" should not exist


  Scenario: Generate a Web User Interface connected to a model
    When I overwrite "lib/wheelie/metamodel.rb" with:
      """
      metamodel 'Test' do |test|
        model 'Customer' do |customer|
          customer.attr :name
          customer.attr :age, type: :integer

          customer.attr :email
          customer.attr :revenue, type: :money
          customer.attr :homepage, type: :url, default: 'http://www.makandra.de'
          customer.attr :locked, type: :flag, default: false
        end

        test.wui 'Customer', model: 'Customer' do |wui|
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
    Then the file "app/controllers/customers_controller.rb" should contain exactly:
      """
      class CustomersController < ApplicationController

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
          @object ||= Customer.build
          @object.attributes = params[:customer]
        end

        def load_object
          @object ||= Customer.find(params[:id])
        end

        def load_collection
          @collection ||= Customer.all
        end

      end

      """
    And the file "app/views/customers/index.html.haml" should contain exactly:
      """
      .title
        Customers

      .tools
        = link_to 'Add customer', new_customer_path, class: 'button'
        = link_to 'Collection Action', collection_action_customers_path, class: 'button'

      %table.items
        - @collection.each do |customer|
          %tr
            %td
              = link_to customer.to_s, customer_path(customer), class: 'hyperlink'
            %td.items__actions
              = link_to 'Edit', edit_customer_path(customer), class: 'items__action'
              = link_to 'Destroy', customer_path(customer), method: :delete, class: 'items__action', confirm: 'Really destroy?'

      """
    And the file "app/views/customers/show.html.haml" should contain exactly:
      """
      .title
        = @object.to_s

      .tools
        = link_to 'All customers', customers_path, class: 'button'
        = link_to 'Edit', edit_customer_path(@object), class: 'button is_primary'
        = link_to 'Destroy', customer_path(@object), method: :delete, class: 'button', confirm: 'Really destroy?'
        = link_to 'Member Action', member_action_customer_path(@object), class: 'button'

      %dl.values
        %dt
          = Customer.human_attribute_name(:name)
        %dd
          = @object.name
        %dt
          = Customer.human_attribute_name(:age)
        %dd
          = @object.age
        %dt
          = Customer.human_attribute_name(:email)
        %dd
          = mail_to @object.email, class: 'hyperlink'
        %dt
          = Customer.human_attribute_name(:revenue)
        %dd
          = @object.revenue
          €
        %dt
          = Customer.human_attribute_name(:homepage)
        %dd
          = link_to @object.homepage, @object.homepage, class: 'hyperlink'
        %dt
          = Customer.human_attribute_name(:locked)
        %dd
          = yes_no(@object.locked)

      """
    And the file "app/views/customers/new.html.haml" should contain exactly:
      """
      .title
        Add customer

      = render 'form'

      """
    And the file "app/views/customers/edit.html.haml" should contain exactly:
      """
      .title
        = @object.to_s

      = render 'form'

      """
    And the file "app/views/customers/_form.html.haml" should contain exactly:
      """
      = form_for @object do |form|

        .tools
          = button_tag 'Save', class: 'button is_primary'
          - cancel_path = @object.new_record? ? customers_path : customer_path(@object)
          = link_to 'Cancel', cancel_path, class: 'button'

        %dl.controls
          %dt
            = form.label :name
          %dd
            = form.text_field :name
          %dt
            = form.label :age
          %dd
            = form.number_field :age
          %dt
            = form.label :email
          %dd
            = form.text_field :email
          %dt
            = form.label :revenue
          %dd
            = form.number_field :revenue
            €
          %dt
            = form.label :homepage
          %dd
            = form.text_field :homepage
          %dt
            = form.label :locked
          %dd
            = form.check_box :locked

      """
    And the file "app/views/customers/member_action.html.haml" should contain exactly:
      """
      .title
        Member Action

      .tools
        = link_to 'All customers', customers_path, class: 'button'

      """
    And the file "app/views/customers/collection_action.html.haml" should contain exactly:
      """
      .title
        Collection Action

      """
