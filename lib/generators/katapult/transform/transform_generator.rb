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
      unless File.read('config/routes.rb').include? '  root'
        root_wui = @app_model.wuis.find { |w| w.find_action :index }
        route "root '#{ root_wui.model_name(:variables) }#index'" if root_wui
      end
    end

    def remigrate_all_databases
      # run 'spring stop' # parallel_tests does not work together with Spring
      run 'rake db:drop db:create db:migrate parallel:drop parallel:create parallel:prepare'
    end

  private

    def application_name
       File.basename(Dir.pwd)
    end

    def run(*)
      Bundler.with_clean_env do
        super
      end
    end

  end
end
