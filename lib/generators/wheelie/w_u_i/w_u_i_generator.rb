require 'rails/generators/resource_helpers'

module Wheelie
  module Generators
    class WUIGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      desc 'Generate a Web User Interface'

      check_class_collision suffix: 'Controller'
      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled_object(args)

        super
      end

      def create_controller_file
        template 'controller.rb', controller_file_path
      end

      private

      # Normally, generators don't take objects as argument. However, we need a
      # model object for generating it. Replace the model object with its name
      # before calling super, so the generator doesn't notice.
      def extract_smuggled_object(args)
        if args.first.is_a? Wheelie::WUI
          @wui = args.shift
          args.unshift @wui.name.underscore
        end
      end

      def controller_file_path
        File.join('app', 'controllers', "#{controller_file_name}_controller.rb")
      end

    end
  end
end
