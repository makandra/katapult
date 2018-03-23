# Generate files and directories from an application model file. Afterwards do
# any setup left necessary (e.g. updating the database).

# A normal #require would load the application model from the generated app
require_relative '../../../katapult/application_model'
require 'katapult/support/generator_goodies'

module Katapult
  class TransformGenerator < Rails::Generators::Base
    include Katapult::GeneratorGoodies

    desc 'Transform the katapult application model'

    argument :path, required: true, type: :string,
      description: 'The path to the application model file'

    def transform_application_model
      say_status :parse, path
      application_model = File.read(path)
      @app_model = Katapult::ApplicationModel.parse(application_model, path)

      say_status :render, "into #{app_name}"
      @app_model.render options.slice(:force)
    end

    def write_root_route
      unless File.read('config/routes.rb').include? '  root'
        root_web_ui = @app_model.web_uis.find { |w| w.find_action :index }
        route "root '#{ root_web_ui.model_name(:variables) }#index'" if root_web_ui
      end
    end

    def remigrate_all_databases
      return if ENV['SKIP_MIGRATIONS'] # Used to speed up tests

      bundle_exec 'rake db:drop db:create db:migrate'
      # See comment to Katapult::BasicsGenerator#create_databases
      run 'unset RAILS_ENV; bundle exec rake parallel:drop parallel:create parallel:prepare'
    end

  end
end
