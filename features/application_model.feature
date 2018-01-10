#@announce-output
Feature: The application model prepared by Katapult

  Scenario: Generating the application model template
    Given a new Rails application with Katapult basics installed

    When I generate the application model
    Then the file "lib/katapult/application_model.rb" should contain:
    """
    # Define a model + generate views with CRUD actions
    # Since this generates the first web UI with an index action, the products list
    # will become the home page of the generated app
    crud 'product' do |product|
      # The first attribute of each model is taken as a human identifier/label
      product.attr :title # Default type "string"

      # The order of attributes is respected when generating the form for that model
      product.attr :price, type: :money
      product.attr :mode, assignable_values: %w[public private]
      product.attr :provider, type: :url
      product.attr :import_data, type: :json
    end

    # Define a model
    model 'user' do |user|
      user.attr :email # Type "email" derived from attribute name

      user.attr :name
      user.attr :last_visit, type: :datetime
      user.attr :locked, type: :flag, default: false
    end

    # Add a web user interface for the 'user' model
    web_ui 'user' do |web_ui|
      # All CRUD actions: index, show, new, create, edit, update, destroy
      web_ui.crud

      # Custom action
      web_ui.action :lock, scope: :member, method: :post
    end

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
