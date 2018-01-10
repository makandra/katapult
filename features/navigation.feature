#@announce-stderr
Feature: Navigation

  Background:
    Given a new Rails application with Katapult basics installed


  Scenario: Generate navigation

    A navigation is rendered from all WebUIs in the application model. It
    consists of links to their index pages.

    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'Customer' do |customer|
        customer.attr :name
      end
      web_ui 'Customer', &:crud

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

    The first WebUI with an index action is set as home page. This does not
    require a navigation.

    When I write to "lib/katapult/application_model.rb" with:
      """
      model('Customer') { |c| c.attr :name }
      model('Elephant') { |e| e.attr :name }

      web_ui 'Elephant' do |web_ui|
        web_ui.action :trumpet, scope: :member, method: :post
      end

      web_ui 'Customer' do |web_ui|
        web_ui.crud
      end
      """
    And I successfully transform the application model
    Then the file "config/routes.rb" should contain:
      """
      root 'customers#index'
      """
