# Generate a controller, routes and view files for a WUI.

require 'katapult/generator'
require 'generators/katapult/haml/haml_generator'

module Katapult
  module Generators
    class WUIGenerator < Katapult::Generator

      desc 'Generate a Web User Interface'

      check_class_collision suffix: 'Controller'
      source_root File.expand_path('../templates', __FILE__)


      def create_controller_file
        template 'controller.rb', File.join('app', 'controllers', "#{ model_name(:variables) }_controller.rb")
      end

      def add_route
        route render_partial('_route.rb')
      end

      def generate_views
        Generators::HamlGenerator.new(wui).invoke_all
      end

      no_tasks do
        def method_name(name)
          case name
          when :load_collection then "load_#{model_name :variables}"
          when :load_object     then "load_#{model_name :variable}"
          when :build           then "build_#{model_name :variable}"
          when :save            then "save_#{model_name :variable}"
          when :params          then "#{model_name :variable}_params"
          when :scope           then "#{model_name :variable}_scope"
          end
        end

        def model_name(kind = nil)
          wui.model_name(kind)
        end

        def navigation
          wui.application_model.navigation
        end
      end

      private

      def wui
        @element
      end

    end
  end
end
