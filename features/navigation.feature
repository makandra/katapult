Feature: Navigation

  Background:
    Given a pristine Rails application
    And I install wheelie
    And I generate wheelie basics


  Scenario: Generate navigation

    The navigation is rendered from all WUIs in the metamodel. It consists of
    links to their index pages.

    When I overwrite "lib/wheelie/metamodel.rb" with:
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
    And I successfully render the metamodel
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
