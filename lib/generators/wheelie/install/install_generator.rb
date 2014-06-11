module Wheelie
  class InstallGenerator < Rails::Generators::Base
    desc 'Install wheelie into a Rails app'
  
    def setup_lib
      create_file 'lib/wheelie/metamodel.rb', <<-METAMODEL
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
      METAMODEL
    end

  end
end
