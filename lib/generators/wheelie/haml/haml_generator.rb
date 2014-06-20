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
          file_name = "#{action.name}.html.haml"

          create_view file_name, File.join(views_path, file_name)
        end
      end

      def create_form_partial_if_needed
        _form_actions = (wui.actions.map(&:name) & %w[new edit])

        if _form_actions.any?
          file_name = '_form.html.haml'

          create_view file_name, File.join(views_path, file_name)
        end
      end

      def create_views_for_custom_actions
        wui.custom_actions.select(&:get?).each do |action|
          @action = action # Make the action object accessible in templates
          create_view 'custom_action.html.haml', File.join(views_path, "#{action.name}.html.haml")
        end
      end

      private

      def views_path
        File.join('app', 'views', controller_file_name)
      end

      def routes
        wui.model.routes
      end

      def names
        wui.model.names
      end

      # Rails views depend heavily on models. If the WUI has no model, do not
      # use the templates but create empty files instead.
      def create_view(template, destination)
        if wui.model
          template template, destination
        else
          create_file destination
        end
      end

    end
  end
end
