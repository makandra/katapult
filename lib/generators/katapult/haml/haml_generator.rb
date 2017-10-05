# Generate views for a WUI.

require 'katapult/generator'
require 'generators/katapult/cucumber_features/cucumber_features_generator'

module Katapult
  module Generators
    class HamlGenerator < Katapult::Generator

      desc 'Generate HAML views'
      source_root File.expand_path('../templates', __FILE__)


      def create_views_directory
        FileUtils.mkdir_p views_path
      end

      def create_rails_standard_action_views
        actions.select{ |a| a.get? && WUI::RAILS_ACTIONS.include?(a.name) }.each do |action|
          file_name = "#{action.name}.html.haml"

          create_view file_name, File.join(views_path, file_name)
        end
      end

      def create_form_partial_if_needed
        _form_actions = (actions.map(&:name) & %w[new edit])

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

      def generate_integration_tests
        if wui.model.present?
          Generators::CucumberFeaturesGenerator.new(wui.model).invoke_all
        end
      end

      no_tasks do
        def model_name(kind = nil)
          wui.model_name(kind)
        end

        def views_path
          File.join('app', 'views', model_name(:variables))
        end
      end

      private

      # Rails views depend heavily on models. If the WUI has no model, do not
      # use the templates but create empty files instead.
      def create_view(template, destination)
        if wui.model
          template template, destination
        else
          create_file destination
        end
      end

      def wui
        @element
      end

      def actions
        wui.actions
      end

    end
  end
end
