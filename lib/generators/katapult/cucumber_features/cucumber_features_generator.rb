require 'katapult/generator'

module Katapult
  module Generators
    class CucumberFeaturesGenerator < Katapult::Generator

      desc 'Generate Cucumber features for CRUD'
      source_root File.expand_path('../templates', __FILE__)


      def create_crud_feature
        template 'feature.feature', "features/#{model.name(:variables)}.feature"
      end

      private

      def model
        @element
      end

    end
  end
end
