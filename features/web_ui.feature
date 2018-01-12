#@announce-output
#@announce-stderr
Feature: Web User Interface

  Background:
    Given a new Rails application with Katapult basics installed


  Scenario: Generate a Web User Interface
    When I write to "lib/katapult/application_model.rb" with:
      """
      crud 'customer' do |customer|
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

        customer.belongs_to 'project'
      end

      model('project') { |p| p.attr :title }
      """
    And I successfully transform the application model including migrations
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
          save_customer
        end

        def edit
          load_customer
          build_customer
        end

        def update
          load_customer
          build_customer
          save_customer
        end

        def destroy
          load_customer
          @customer.destroy
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
          @customer ||= customer_scope.new
          @customer.attributes = customer_params
        end

        def save_customer
          if @customer.save
            redirect_to @customer
          else
            action = @customer.new_record? ? 'new' : 'edit'
            render action, status: :unprocessable_entity
          end
        end

        def customer_params
          customer_params = params[:customer]
          return {} if customer_params.blank?

          customer_params.permit(
            :name,
            :age,
            :email,
            :password,
            :revenue,
            :homepage,
            :locked,
            :notes,
            :first_visit,
            :indexable_data,
            :plain_data,
            :project_id,
          )
        end

        def customer_scope
          Customer.scoped
        end

      end

      """
    And the file "config/routes.rb" should contain:
      """
        resources :customers
      """
    And the file "app/helpers/table_helper.rb" should contain "def table(*headers, &block)"

    And a file named "app/webpack/assets/stylesheets/blocks/action_bar.sass" should exist
    And a file named "app/webpack/assets/stylesheets/blocks/title.sass" should exist

    And the file "app/views/customers/index.html.haml" should contain exactly:
      """
      .action-bar.-main.btn-group
        = link_to 'Add customer', new_customer_path, class: 'btn btn-default'

      %h1.title
        Customers

      - if @customers.any?

        = table 'Name', 'Actions' do
          - @customers.each do |customer|
            %tr(up-expand)
              %td(width='40%')
                = link_to customer, customer
              %td
                = link_to 'Edit', edit_customer_path(customer)
                = link_to 'Destroy', customer_path(customer), method: :delete,
                  class: 'text-danger',
                  data: { confirm: 'Really destroy?' }, title: "Destroy #{customer}"

      - else
        %p.help-block
          No customers found.

      """
    And the file "app/views/customers/show.html.haml" should contain exactly:
      """
      .action-bar.-main.btn-group
        = link_to 'All customers', customers_path, class: 'btn btn-default'
        = link_to 'Edit', edit_customer_path(@customer), class: 'btn btn-default'

      %h1.title
        = @customer

      %dl
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
          = mail_to @customer.email, nil
        %dt
          = Customer.human_attribute_name(:revenue)
        %dd
          = @customer.revenue
          €
        %dt
          = Customer.human_attribute_name(:homepage)
        %dd
          = link_to @customer.homepage, @customer.homepage
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
        %dt
          = Customer.human_attribute_name(:project_id)
        %dd
          = @customer.project

      """
    And the file "app/views/customers/new.html.haml" should contain exactly:
      """
      %h1.title
        Add customer

      = render 'form'

      """
    And the file "app/views/customers/edit.html.haml" should contain exactly:
      """
      %h1.title
        = @customer

      = render 'form'

      """
    And the file "app/views/customers/_form.html.haml" should contain exactly:
      """
      = form_for @customer do |form|

        .form-group
          = form.label :name
          = form.text_field :name, class: 'form-control'
        .form-group
          = form.label :age
          = form.number_field :age, class: 'form-control'
        .form-group
          = form.label :email
          = form.email_field :email, class: 'form-control'
        .form-group
          = form.label :password
          = form.password_field :password, class: 'form-control',
            autocomplete: 'new-password'
        .form-group
          = form.label :revenue
          .input-group
            = form.number_field :revenue, class: 'form-control'
            .input-group-addon
              €
        .form-group
          = form.label :homepage
          = form.url_field :homepage, class: 'form-control'
        .form-group
          = form.label :locked
          .checkbox
            = form.label :locked do
              = form.check_box :locked
        .form-group
          = form.label :notes
          = form.text_area :notes, rows: 5, class: 'form-control'
        .form-group
          = form.label :first_visit
          = form.date_field :first_visit, class: 'form-control'
        .form-group
          = form.label :project_id
          = form.collection_select :project_id, form.object.assignable_projects,
            :id, :title, { include_blank: true }, class: 'form-control'

        .action-bar
          - cancel_path = @customer.new_record? ? customers_path : customer_path(@customer)

          .pull-right
            - if @customer.persisted?
              = link_to "Destroy customer", customer_path(@customer), method: :delete,
                class: 'btn btn-danger', data: { confirm: 'Really destroy?' }

          = form.submit 'Save', class: 'btn btn-primary'
          = link_to 'Cancel', cancel_path, class: 'btn btn-link'

      """
    # Note that no form fields are generated for JSON fields, as they are mainly
    # data storage fields

    And the file "features/customers.feature" should contain exactly:
      """
      Feature: Customers

        Scenario: CRUD customers
          Given I am on the list of customers
            And there is a project with the title "title-string"

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
            And I select "title-string" from "Project"
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
            And I should see "title-string"

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
            And "title-string" should be selected for "Project"

          # destroy
          When I go to the list of customers
          Then I should see "name-string"

          When I follow "Destroy name-string"
          Then I should be on the list of customers
          But I should not see "name-string"

      """
    When I run cucumber
    Then the features should pass


  Scenario: Generate a Web User Interface with custom actions
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'customer' do |customer|
        customer.attr :name
      end

      web_ui 'customer', model: 'customer' do |web_ui|
        web_ui.crud
        web_ui.action :get_member, method: :get, scope: :member
        web_ui.action :post_member, method: :post, scope: :member
        web_ui.action :get_collection, method: :get, scope: :collection
        web_ui.action :put_collection, method: :put, scope: :collection
      end
      """
    And I successfully transform the application model
    Then the file "app/controllers/customers_controller.rb" should contain:
      """

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
    And the file "app/views/customers/index.html.haml" should contain:
      """
        = link_to 'Get Collection', get_collection_customers_path, class: 'btn btn-default'
        = link_to 'Put Collection', put_collection_customers_path, class: 'btn btn-default'
      """
    And the file "app/views/customers/show.html.haml" should contain:
      """
        = link_to 'Get Member', get_member_customer_path(@customer), class: 'btn btn-default'
        = link_to 'Post Member', post_member_customer_path(@customer), class: 'btn btn-default', method: :post
      """
    And the file "app/views/customers/get_member.html.haml" should contain exactly:
      """
      .action-bar
        = link_to 'All customers', customers_path, class: 'btn btn-default'

      %h1.title
        Get Member

      """
    But a file named "app/views/customers/post_member.html.haml" should not exist
    And the file "app/views/customers/get_collection.html.haml" should contain exactly:
      """
      .action-bar
        = link_to 'All customers', customers_path, class: 'btn btn-default'

      %h1.title
        Get Collection

      """
    But a file named "app/views/customers/put_collection.html.haml" should not exist
