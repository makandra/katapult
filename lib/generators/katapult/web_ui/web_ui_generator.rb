# Generate a controller, routes and view files for a WebUI instance

require 'katapult/generator'
require 'generators/katapult/views/views_generator'

module Katapult
  module Generators
    class WebUIGenerator < Katapult::Generator

      desc 'Generate a Web User Interface'

      check_class_collision suffix: 'Controller'
      source_root File.expand_path('../templates', __FILE__)


      def create_controller_file
        template 'controller.rb', File.join('app', 'controllers', "#{ model_name(:variables) }_controller.rb")
      end

      def add_route
        route = model_name(:symbols)
        routes = File.read('config/routes.rb')

        if routes =~ /^\s+resources #{ route }/
          say_status :warn, <<MESSAGE, :red
Routes for #{ route } already exist! Not updated.
In order to keep existing routes created by the user, the config/routes.rb file
is not wiped on model transformation. To have Katapult update the #{ route }
route for you, delete it before transforming the application model.
MESSAGE
        elsif web_ui.crud_only?
          route "resources #{ route }"
        else
          route render_partial('_route.rb')
        end
      end

      def generate_views
        Generators::ViewsGenerator.new(web_ui).invoke_all
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
          web_ui.model_name(kind)
        end
      end

      private

      def web_ui
        @element
      end

    end
  end
end
