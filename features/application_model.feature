#@announce-output
Feature: The application model prepared by Katapult

  Scenario: Generating the application model template
    Given a new Rails application with Katapult basics installed

    When I generate the application model
    Then the file "lib/katapult/application_model.rb" should contain:
    """
    # Define models
    model 'user' do |user|
      user.attr :email
      user.attr :name
      user.attr :last_visit, type: :datetime
      user.attr :locked, type: :flag, default: false
    end

    model 'product' do |product|
      product.attr :title
      product.attr :price, type: :money
      product.attr :mode, assignable_values: %w[public private]
      product.attr :provider, type: :url
      product.attr :import_data, type: :json
    end

    # Add web user interfaces
    wui 'user' do |wui|
      wui.crud # Creates all CRUD actions: index, new, show, etc.
      wui.action :lock, scope: :member, method: :post
    end

    wui 'product', &:crud

    # Have a main menu
    navigation

    # Add authentication
    authenticate 'user', system_email: 'system@example.com'

    """

    When I successfully transform the application model including migrations
      And I run cucumber
    Then the features should pass

    When I run rspec
    Then the specs should pass
