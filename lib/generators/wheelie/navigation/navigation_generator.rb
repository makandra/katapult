require 'wheelie/generator'

module Wheelie
  module Generators
    class NavigationGenerator < Wheelie::Generator

      attr_accessor :navigation

      desc 'Generate the navigation'
      source_root File.expand_path('../templates', __FILE__)


      def create_navigation
        template 'app/models/navigation.rb'
      end

      private

      def set_wheelie_model(model_object)
        self.navigation = model_object
      end

    end
  end
end
