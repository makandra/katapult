require 'rails/generators/resource_helpers'

module Wheelie
  module Generators
    class HamlGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      attr_accessor :wui

      desc 'Generate HAML views'

      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled_object(args)

        super
      end

      def create_views
        wui.actions.any? or return 'Have no actions, get no views'

        FileUtils.mkdir_p views_path

        # create Rails standard action views
        wui.rails_view_actions.each do |action|
          action_file = "#{action.name}.html.haml"
          template action_file, File.join(views_path, action_file)
        end

        # create _form partial, if needed
        _form_actions = (wui.actions.map(&:name) & %w[new edit])
        if _form_actions.any?
          action_file = '_form.html.haml'
          template action_file, File.join(views_path, action_file)
        end

        # create views for custom actions
        wui.custom_actions.each do |action|
          template 'custom_action.html.haml', File.join(views_path, "#{action.name}.html.haml")
        end
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

      def views_path
        File.join('app', 'views', controller_file_name)
      end

    end
  end
end
