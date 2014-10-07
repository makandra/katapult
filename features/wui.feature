Feature: Web User Interface

  Background:
    Given a pristine Rails application
    And I install wheelie
    And I generate wheelie basics


  Scenario: Generate a Web User Interface
    When I overwrite "lib/wheelie/application_model.rb" with:
      """
      model 'Customer' do |customer|
        customer.attr :name
        customer.attr :age, type: :integer

        customer.attr :email
        customer.attr :revenue, type: :money
        customer.attr :homepage, type: :url, default: 'http://www.makandra.de'
        customer.attr :locked, type: :flag, default: false

        customer.label_attr = :name
      end

      wui 'Customer', model: 'Customer' do |wui|
        wui.crud
        wui.action :get_member, method: :get, scope: :member
        wui.action :post_member, method: :post, scope: :member
        wui.action :get_collection, method: :get, scope: :collection
        wui.action :put_collection, method: :put, scope: :collection
      end
      """
    And I successfully render the application model
    Then the file "app/controllers/customers_controller.rb" should contain exactly:
      """
      class CustomersController < ApplicationController

        def index
          load_customers
        end

        def show
          load_customer
        end

        def new
          build_customer
        end

        def create
          build_customer
          save_customer or render :new
        end

        def edit
          load_customer
          build_customer
        end

        def update
          load_customer
          build_customer
          save_customer or render :edit
        end

        def destroy
          load_customer
          @customer.destroy
          redirect_to customers_path
        end

        def get_member
          load_customer
        end

        def post_member
          load_customer
          redirect_to @customer
        end

        def get_collection
          load_customers
        end

        def put_collection
          load_customers
          redirect_to customers_path
        end

        private

        def load_customers
          @customers ||= customer_scope.to_a
        end

        def load_customer
          @customer ||= customer_scope.find(params[:id])
        end

        def build_customer
          @customer ||= customer_scope.build
          @customer.attributes = customer_params
        end

        def save_customer
          if @customer.save
            redirect_to @customer
          end
        end

        def customer_params
          customer_params = params[:customer]
          customer_params ? customer_params.permit([:name, :age, :email, :revenue, :homepage, :locked]) : {}
        end

        def customer_scope
          Customer.scoped
        end

      end

      """
    And the file "config/routes.rb" should contain:
      """
        resources :customers, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
          member do
            get 'get_member'
            post 'post_member'
          end
          collection do
            get 'get_collection'
            put 'put_collection'
          end
        end
      """
    And the file "app/views/customers/index.html.haml" should contain exactly:
      """
      %h1
        Customers

      .tools
        = link_to 'Add customer', new_customer_path, class: 'tools__button is_primary'
        = link_to 'Get Collection', get_collection_customers_path, class: 'tools__button'
        = link_to 'Put Collection', put_collection_customers_path, class: 'tools__button'

      - if @customers.any?
        %table.items
          - @customers.each do |customer|
            %tr
              %td
                = link_to customer.to_s, customer, class: 'hyperlink'
              %td
                .items__actions
                  = link_to 'Edit', edit_customer_path(customer), class: 'items__action'
                  = link_to 'Destroy', customer_path(customer), method: :delete, class: 'items__action', confirm: 'Really destroy?'
                  = link_to 'Get Member', get_member_customer_path(customer), class: 'items__action'
                  = link_to 'Post Member', post_member_customer_path(customer), class: 'items__action', method: :post

      - else
        %p.help-block
          There are no customers yet.

      """
    And the file "app/views/customers/show.html.haml" should contain exactly:
      """
      %h1
        = @customer.to_s

      .tools
        = link_to 'All customers', customers_path, class: 'tools__button'
        = link_to 'Edit', edit_customer_path(@customer), class: 'tools__button is_primary'
        = link_to 'Destroy', customer_path(@customer), method: :delete, class: 'tools__button', confirm: 'Really destroy?'
        = link_to 'Get Member', get_member_customer_path(@customer), class: 'tools__button'
        = link_to 'Post Member', post_member_customer_path(@customer), class: 'tools__button', method: :post

      %dl.values
        %dt
          = Customer.human_attribute_name(:name)
        %dd
          = @customer.name
        %dt
          = Customer.human_attribute_name(:age)
        %dd
          = @customer.age
        %dt
          = Customer.human_attribute_name(:email)
        %dd
          = mail_to @customer.email, nil, class: 'hyperlink'
        %dt
          = Customer.human_attribute_name(:revenue)
        %dd
          = @customer.revenue
          €
        %dt
          = Customer.human_attribute_name(:homepage)
        %dd
          = link_to @customer.homepage, @customer.homepage, class: 'hyperlink'
        %dt
          = Customer.human_attribute_name(:locked)
        %dd
          = @customer.locked ? 'Yes' : 'No'

      """
    And the file "app/views/customers/new.html.haml" should contain exactly:
      """
      %h1
        Add customer

      = render 'form'

      """
    And the file "app/views/customers/edit.html.haml" should contain exactly:
      """
      %h1
        = @customer.to_s

      = render 'form'

      """
    And the file "app/views/customers/_form.html.haml" should contain exactly:
      """
      = form_for @customer do |form|

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
            = form.email_field :email
          %dt
            = form.label :revenue
          %dd
            = form.number_field :revenue
            €
          %dt
            = form.label :homepage
          %dd
            = form.url_field :homepage
          %dt
            = form.label :locked
          %dd
            = form.check_box :locked

        .tools
          = form.submit 'Save', class: 'tools__button is_primary'
          - cancel_path = @customer.new_record? ? customers_path : customer_path(@customer)
          = link_to 'Cancel', cancel_path, class: 'tools__button'

      """
    And the file "app/views/customers/get_member.html.haml" should contain exactly:
      """
      %h1
        Get Member

      .tools
        = link_to 'All customers', customers_path, class: 'tools__button'

      """
    But a file named "app/views/customers/post_member.html.haml" should not exist
    And the file "app/views/customers/get_collection.html.haml" should contain exactly:
      """
      %h1
        Get Collection

      .tools
        = link_to 'All customers', customers_path, class: 'tools__button'

      """
    But a file named "app/views/customers/put_collection.html.haml" should not exist
    And the file "features/customers.feature" should contain exactly:
      """
      Feature: Customers

        Scenario: CRUD customers
          Given I am on the list of customers

          # create
          When I follow "Add customer"
            And I fill in "Name" with "name-string"
            And I fill in "Age" with "778"
            And I fill in "Email" with "email@wheelie.com"
            And I fill in "Revenue" with "2.21"
            And I fill in "Homepage" with "homepage.wheelie.com"
            And I check "Locked"
            And I press "Save"

          # read
          Then I should be on the page for the customer above
            And I should see "name-string"
            And I should see "778"
            And I should see "email@wheelie.com"
            And I should see "2.21"
            And I should see "homepage.wheelie.com"
            And I should see "Locked Yes"

          # update
          When I follow "Edit"
          Then I should be on the form for the customer above
            And the "Name" field should contain "name-string"
            And the "Age" field should contain "778"
            And the "Email" field should contain "email@wheelie.com"
            And the "Revenue" field should contain "2.21"
            And the "Homepage" field should contain "homepage.wheelie.com"
            And the "Locked" checkbox should be checked

          # destroy
          When I go to the list of customers
          Then I should see "name-string"

          When I follow "Destroy"
          Then I should be on the list of customers
            But I should not see "name-string"

      """
    And the features should pass
