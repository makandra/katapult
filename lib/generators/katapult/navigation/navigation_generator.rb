# Generate navigation.

require 'katapult/generator'

module Katapult
  module Generators
    class NavigationGenerator < Katapult::Generator

      desc 'Generate the navigation'
      source_root File.expand_path('../templates', __FILE__)


      def create_navigation
        template 'app/views/layouts/_navigation.html.haml'

        layout = 'app/views/layouts/application.html.haml'
        inject_into_file layout, <<-CONTENT, after: "render 'layouts/flashes'\n"
        = render 'layouts/navigation'
        CONTENT

      end

      private

      def navigation
        @element
      end

      def links
        {}.tap do |map|
          wuis_with_index = navigation.wuis.select do |wui|
            wui.find_action(:index).present?
          end

          wuis_with_index.each do |wui|
            label = wui.model_name :humans
            map[label] = wui.path(:index)
          end
        end
      end

    end
  end
end
