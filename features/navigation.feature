Feature: Navigation

  Background:
    Given a pristine Rails application
    And I install wheelie
    And I generate wheelie basics


  Scenario: Generate navigation

    The navigation is rendered from all WUIs in the application model. It
    consists of links to their index pages.

    When I overwrite "lib/wheelie/application_model.rb" with:
      """
      model 'Customer' do |customer|
        customer.attr :name
        customer.label_attr = :name
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
    And I successfully render the application model
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


  Scenario: Set homepage (aka root route)
    When I overwrite "lib/wheelie/application_model.rb" with:
      """
      model 'Customer' do |customer|
        customer.attr :name
        customer.label_attr = :name
      end

      wui 'Customer', model: 'Customer' do |wui|
        wui.action :index
        wui.action :show
        wui.action :create
        wui.action :update
        wui.action :destroy
      end

      homepage 'Customer'
      """
    And I successfully render the application model
    Then the file "config/routes.rb" should contain:
      """
      root 'customers#index'
      """
