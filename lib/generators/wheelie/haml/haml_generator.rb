require 'rails/generators/resource_helpers'
require 'wheelie/generator'

module Wheelie
  module Generators
    class HamlGenerator < Wheelie::Generator
      include Rails::Generators::ResourceHelpers

      attr_accessor :wui

      desc 'Generate HAML views'
      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled(Wheelie::WUI, :wui, args)
        super
      end

      def create_views_directory
        wui.actions.any? or return 'Have no actions, get no views'

        FileUtils.mkdir_p views_path
      end

      def create_rails_standard_action_views
        wui.rails_view_actions.each do |action|
          action_file = "#{action.name}.html.haml"
          template action_file, File.join(views_path, action_file)
        end
      end

      def create_form_partial_if_needed
        _form_actions = (wui.actions.map(&:name) & %w[new edit])

        if _form_actions.any?
          action_file = '_form.html.haml'
          template action_file, File.join(views_path, action_file)
        end
      end

      def create_views_for_custom_actions
        wui.custom_actions.each do |action|
          template 'custom_action.html.haml', File.join(views_path, "#{action.name}.html.haml")
        end
      end

      private

      def views_path
        File.join('app', 'views', controller_file_name)
      end

    end
  end
end
