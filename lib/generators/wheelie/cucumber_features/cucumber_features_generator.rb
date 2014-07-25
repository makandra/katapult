require 'wheelie/generator'

module Wheelie
  module Generators
    class CucumberFeaturesGenerator < Wheelie::Generator

      desc 'Generate Cucumber features for CRUD'
      source_root File.expand_path('../templates', __FILE__)


      def create_crud_feature
        template 'feature.feature', "features/#{model_name(:variables)}.feature"
      end

      no_tasks do
        def model_name(kind = nil)
          wui.model_name(kind)
        end

        def model_attrs
          wui.model.attrs
        end
      end

      private

      def wui
        @element
      end

    end
  end
end
