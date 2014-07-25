require 'wheelie/generator'

module Wheelie
  module Generators
    class NavigationGenerator < Wheelie::Generator

      desc 'Generate the navigation'
      source_root File.expand_path('../templates', __FILE__)


      def create_navigation
        template 'app/models/navigation.rb'
      end

      private

      def navigation
        @element
      end

    end
  end
end
