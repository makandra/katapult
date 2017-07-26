# Generate files and directories from an application model file. Afterwards do
# any setup left necessary (e.g. updating the database).

# The application model transformation is split into two parts:
# 1) parse the model into an object-based representation
# 2) render the parsed model into code

require 'katapult/parser'
require 'katapult/generator_goodies'

module Katapult
  class TransformGenerator < Rails::Generators::Base
    include Katapult::GeneratorGoodies

    desc 'Transform the katapult application model'

    argument :path, required: true, type: :string,
      description: 'The path to the application model file'

    def transform_application_model
      say_status :parse, path
      @app_model = Katapult::Parser.new.parse(path)

      say_status :render, "into #{app_name}"
      @app_model.render
    end

    def write_root_route
      unless File.read('config/routes.rb').include? '  root'
        root_wui = @app_model.wuis.find { |w| w.find_action :index }
        route "root '#{ root_wui.model_name(:variables) }#index'" if root_wui
      end
    end

    def remigrate_all_databases
      run 'rake db:drop db:create db:migrate'

      # Need to unset RAILS_ENV variable for this sub command because
      # parallel_tests defaults to "test" only if the variable is not set (<->
      # empty string value). However, because this is run from a Rails
      # generator, the variable is already set to "development". Cannot set to
      # "test" either because parallel_tests is only loaded in development.
      run 'unset RAILS_ENV; rake parallel:drop parallel:create parallel:prepare'
    end

  end
end
