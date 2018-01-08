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
      return if ENV['SKIP_MIGRATIONS'] # Used to speed up tests

      run 'rake db:drop db:create db:migrate'
      # See comment to Katapult::BasicsGenerator#create_databases
      run 'unset RAILS_ENV; rake parallel:drop parallel:create parallel:prepare'
    end

  end
end
