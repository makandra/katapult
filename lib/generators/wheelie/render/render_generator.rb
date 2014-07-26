require 'wheelie/parser'

module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie metamodel'
    
    argument :path, required: true, type: :string, description: 'The path to the metamodel file'

    def render_metamodel
      metamodel = Wheelie::Parser.new.parse(path)
      metamodel.render

      if wui = metamodel.home_wui
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
