Feature: Web User Interface

  Background:
    Given a pristine Rails application
    And I install katapult
    And I generate katapult basics


  Scenario: Generate a Web User Interface
    When I overwrite "lib/katapult/application_model.rb" with:
      """
      model 'customer' do |customer|
        customer.attr :name
        customer.attr :age, type: :integer

        customer.attr :email
        customer.attr :password
        customer.attr :revenue, type: :money
        customer.attr :homepage, type: :url, default: 'http://www.makandra.de'
        customer.attr :locked, type: :flag, default: false
        customer.attr :notes, type: :text
        customer.attr :first_visit, type: :datetime
        customer.attr :indexable_data, type: :json
        customer.attr :plain_data, type: :plain_json
      end

      wui 'customer', model: 'customer' do |wui|
        wui.crud
        wui.action :get_member, method: :get, scope: :member
        wui.action :post_member, method: :post, scope: :member
        wui.action :get_collection, method: :get, scope: :collection
        wui.action :put_collection, method: :put, scope: :collection
      end
      """
    And I successfully transform the application model
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
          customer_params ? customer_params.permit(%i[name age email password revenue homepage locked notes first_visit indexable_data plain_data]) : {}
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
                  = link_to 'Destroy', customer_path(customer), method: :delete, class: 'items__action', confirm: 'Really destroy?', title: "Destroy #{customer.to_s}"
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
        %dt
          = Customer.human_attribute_name(:notes)
        %dd
          = simple_format(@customer.notes)
        %dt
          = Customer.human_attribute_name(:first_visit)
        %dd
          = l(@customer.first_visit.to_date) if @customer.first_visit

      """
    # Note that no views are generated for JSON fields, as they are mainly data
    # storage fields

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
            = form.label :password
          %dd
            = form.password_field :password
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
          %dt
            = form.label :notes
          %dd
            = form.text_area :notes, rows: 5
          %dt
            = form.label :first_visit
          %dd
            = form.date_field :first_visit

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
            And I fill in "Email" with "email@example.com"
            And I fill in "Password" with "password-password"
            And I fill in "Revenue" with "2.21"
            And I fill in "Homepage" with "homepage.example.com"
            And I check "Locked"
            And I fill in "Notes" with "notes-text"
            And I fill in "First visit" with "2022-03-25"
            And I press "Save"

          # read
          Then I should be on the page for the customer above
            And I should see "name-string"
            And I should see "778"
            And I should see "email@example.com"
            And I should see "2.21"
            And I should see "homepage.example.com"
            And I should see "Locked Yes"
            And I should see "notes-text"
            And I should see "2022-03-25"

          # update
          When I follow "Edit"
          Then I should be on the form for the customer above
            And the "Name" field should contain "name-string"
            And the "Age" field should contain "778"
            And the "Email" field should contain "email@example.com"
            And the "Revenue" field should contain "2.21"
            And the "Homepage" field should contain "homepage.example.com"
            And the "Locked" checkbox should be checked
            And the "Notes" field should contain "notes-text"
            And the "First visit" field should contain "2022-03-25"

          # destroy
          When I go to the list of customers
          Then I should see "name-string"

          When I follow "Destroy name-string"
          Then I should be on the list of customers
            But I should not see "name-string"

      """

    When I run cucumber
    Then the features should pass


  Scenario: Generate layout file with query diet widget
    When I overwrite "lib/katapult/application_model.rb" with:
      """
      model 'Car'
      wui 'Car'
      """
    And I successfully transform the application model
    Then the file "app/views/layouts/application.html.haml" should contain:
      """
      = query_diet_widget(bad_count: 15) if Rails.env.development?
      """
