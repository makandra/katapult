require 'rails/generators/resource_helpers'
require 'wheelie/generator'

module Wheelie
  module Generators
    class WUIGenerator < Wheelie::Generator
      include Rails::Generators::ResourceHelpers

      attr_accessor :wui

      desc 'Generate a Web User Interface'

      check_class_collision suffix: 'Controller'
      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled(Wheelie::WUI, :wui, args)
        super
      end

      def create_controller_file
        controller_path = File.join('app', 'controllers', "#{controller_file_name}_controller.rb")

        if wui.model
          template 'controller.rb', controller_path
        else
          template 'controller_without_model.rb', controller_path
        end
      end

      def add_route
        route render_partial('_route.rb')
      end

      hook_for :template_engine, required: true do |wui_generator, template_engine|
        wui_generator.invoke template_engine, [ wui_generator.wui, wui_generator.wui.name ]
      end

      private

      def names
        wui.model.names
      end

    end
  end
end
