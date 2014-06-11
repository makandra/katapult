Feature: Wheelie in general

  Scenario: Have Wheelie installed (see Background)
    Given a pristine Rails application with wheelie installed
    Then the file "lib/wheelie/metamodel.rb" should contain exactly:
      """
      metamodel 'kickstart' do |meta|
        # Here you define the fundamentals of your application.
        #
        # Add a model:
        # meta.model 'customer' do |customer|
        #   customer.attr :name
        #   customer.attr :birth, type: date
        #   customer.attr :email
        # end
        #
        # Add a web user interface:
        # meta.wui 'customer' do |wui|
        #   wui.action :index
        #   wui.action :show
        #   wui.action :lock, scope: :member, method: :post
        # end
      end

      """
