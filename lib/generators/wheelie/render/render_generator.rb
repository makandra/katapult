require 'wheelie/parser'

module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie application model'
    
    argument :path, required: true, type: :string,
      description: 'The path to the application model file'

    def render_application_model
      @app_model = Wheelie::Parser.new.parse(path)

      @app_model.render
    end

    def write_root_route
      root_wui = @app_model.wuis.find do |wui|
        wui.find_action :index
      end

      route "root '#{ root_wui.model_name(:variables) }#index'" if root_wui
    end

    def migrate
      run 'bin/rake db:drop:all &> /dev/null'
      run 'bin/rake db:create db:migrate RAILS_ENV=development'
      run 'bin/rake db:create db:migrate RAILS_ENV=test'
    end

  end
end
