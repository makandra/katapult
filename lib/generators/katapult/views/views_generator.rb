# Generate views for a WebUI

require 'katapult/generator'
require 'generators/katapult/cucumber_features/cucumber_features_generator'

module Katapult
  module Generators
    class ViewsGenerator < Katapult::Generator

      desc 'Generate HAML views'
      source_root File.expand_path('../templates', __FILE__)


      def create_views_directory
        FileUtils.mkdir_p views_path
      end

      def install_helpers
        directory 'app/helpers'
      end

      def install_styles
        directory 'app/webpack/assets/stylesheets/blocks'
      end

      def create_rails_standard_action_views
        actions.select{ |a| a.get? && WebUI::RAILS_ACTIONS.include?(a.name) }.each do |action|
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
        web_ui.custom_actions.select(&:get?).each do |action|
          @action = action # Make the action object accessible in templates
          create_view 'custom_action.html.haml', File.join(views_path, "#{action.name}.html.haml")
        end
      end

      def generate_integration_tests
        if web_ui.model.present?
          Generators::CucumberFeaturesGenerator.new(web_ui.model, options).invoke_all
        end
      end

      no_tasks do
        def model_name(kind = nil)
          web_ui.model_name(kind)
        end

        def views_path
          File.join('app', 'views', model_name(:variables))
        end
      end

      private

      # Rails views depend heavily on models. If the WebUI has no model, do not
      # use the templates but create empty files instead.
      def create_view(template, destination)
        if web_ui.model
          template template, destination
        else
          create_file destination
        end
      end

      def web_ui
        @element
      end

      def actions
        web_ui.actions
      end

    end
  end
end
