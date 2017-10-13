#@announce-stderr
Feature: Navigation

  Background:
    Given a new Rails application with Katapult basics installed


  Scenario: Generate navigation

    A navigation is rendered from all WUIs in the application model. It
    consists of links to their index pages.

    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Customer' do |customer|
        customer.attr :name
      end
      wui 'Customer', &:crud

      navigation
      """
    And I successfully transform the application model
    And the file "app/views/layouts/_menu_bar.html.haml" should contain:
    """
    = render 'layouts/navigation'
    """
    And the file "app/views/layouts/_navigation.html.haml" should contain:
    """
    %ul.nav.navbar-nav
      %li(up-expand)
        = content_link_to "Customers", customers_path

      %li.dropdown
        = link_to '#', data: { toggle: 'dropdown' } do
          Dropdown example
          %span.caret

        %ul.dropdown-menu
          %li= link_to 'One', '#'
          %li.divider
          %li= link_to 'Two', '#'
    """


  Scenario: Homepage (aka root route) is set automatically

    The first WUI with an index action is set as home page. This does not
    require a navigation.

    When I write to "lib/katapult/application_model.rb" with:
      """
      model('Customer') { |c| c.attr :name }
      model('Elephant') { |e| e.attr :name }

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
