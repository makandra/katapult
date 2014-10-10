# Generate files and directories from an application model file. Afterwards do
# any setup left necessary (e.g. updating the database).

# The application model transformation is split into two parts:
# 1) parse the model into an object-based representation
# 2) render the parsed model into code

require 'katapult/parser'

module Katapult
  class TransformGenerator < Rails::Generators::Base
    desc 'Transform the katapult application model'

    argument :path, required: true, type: :string,
      description: 'The path to the application model file'


    def transform_application_model
      say_status :parse, path
      @app_model = Katapult::Parser.new.parse(path)

      say_status :render, "into #{application_name}"
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

    private

    def application_name
       File.basename(Dir.pwd)
    end

  end
end
