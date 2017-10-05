@announce-stderr
Feature: Navigation

  Background:
    Given a pristine Rails application
    And I install katapult
    And I generate katapult basics


  Scenario: Generate navigation

    The navigation is rendered from all WUIs in the application model. It
    consists of links to their index pages.

    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Customer' do |customer|
        customer.attr :name
      end

      wui 'Customer', model: 'Customer' do |wui|
        wui.action :index
        wui.action :show
        wui.action :create
        wui.action :update
        wui.action :destroy
      end

      navigation 'main'
      """
    And I successfully transform the application model
    Then the file "app/models/navigation.rb" should contain exactly:
      """
      class Navigation
        include Navy::Description

        navigation :main do
          section :customers, "Customers", customers_path
        end

      end

      """
    And the file "app/views/layouts/application.html.haml" should contain:
      """
      = render_navigation Navigation.main
      """
    And the file "app/controllers/customers_controller.rb" should contain:
      """
      before_filter :set_section
      """
    And the file "app/controllers/customers_controller.rb" should contain:
      """
        def set_section
          in_sections :customers
        end
      """


  Scenario: Homepage (aka root route) is set automatically

    The first WUI with an index action is set as home page

    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Customer'
      model 'Elephant'

      wui 'Elephant' do |wui|
        wui.action :trumpet, scope: :member, method: :post
      end

      wui 'Customer' do |wui|
        wui.crud
      end
      """
    And I successfully transform the application model
    Then the file "config/routes.rb" should contain:
      """
      root 'customers#index'
      """
