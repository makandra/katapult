require 'rails/generators/resource_helpers'

module Wheelie
  module Generators
    class WUIGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      attr_accessor :wui

      desc 'Generate a Web User Interface'

      check_class_collision suffix: 'Controller'
      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled_object(args)

        super
      end

      def create_controller_file
        template 'controller.rb', File.join('app', 'controllers', "#{file_name}_controller.rb")
      end

      hook_for :template_engine, required: true do |wui_generator, template_engine|
        wui_generator.invoke template_engine, [ wui_generator.wui, wui_generator.wui.name ]
      end

      private

      # Normally, generators don't take objects as argument. However, we need a
      # model object for generating it. Replace the model object with its name
      # before calling super, so the generator doesn't notice.
      def extract_smuggled_object(args)
        if args.first.is_a? Wheelie::WUI
          self.wui = args.shift
          args.unshift wui.name.underscore
        end
      end

    end
  end
end
