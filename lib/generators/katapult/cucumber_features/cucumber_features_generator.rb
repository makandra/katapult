require 'katapult/generator'

module Katapult
  module Generators
    class CucumberFeaturesGenerator < Katapult::Generator

      desc 'Generate Cucumber features for CRUD'
      source_root File.expand_path('../templates', __FILE__)


      def create_crud_feature
        template 'feature.feature', "features/#{model.name(:variables)}.feature"
      end

      no_tasks do
        def belongs_tos
          app_model.get_belongs_tos_for model.name
        end
      end

      private

      def model
        @element
      end

      def app_model
        model.application_model
      end

    end
  end
end
