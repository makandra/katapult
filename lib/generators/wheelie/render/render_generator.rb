require 'wheelie/parser'

module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie application model'
    
    argument :path, required: true, type: :string,
      description: 'The path to the application model file'

    def render_application_model
      app_model = Wheelie::Parser.new.parse(path)
      app_model.render

      if wui = app_model.home_wui
        route "root '#{ wui.model_name(:variables) }#index'"
      end
    end

    def migrate
      run 'bin/rake db:drop:all &> /dev/null'
      run 'bin/rake db:create db:migrate RAILS_ENV=development'
      run 'bin/rake db:create db:migrate RAILS_ENV=test'
    end

  end
end
