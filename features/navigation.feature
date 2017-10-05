@announce-stderr
Feature: Navigation

  Background:
    Given a pristine Rails application
    And I install katapult
    And I generate katapult basics


  Scenario: Generate navigation

    A navigation is rendered from all WUIs in the application model. It
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
    Then the file "app/views/layouts/application.html.haml" should contain:
    """
    = render 'layouts/navigation
    """
    And the file "app/views/layouts/_navigation.html.haml" should contain:
    """
    %ul.main-menu.nav.nav-pills
      %li(up-expand)
        = link_to "Customers", customers_path
    """


  Scenario: Homepage (aka root route) is set automatically

    The first WUI with an index action is set as home page. This does not
    require a navigation.

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
