# Generate navigation.

require 'katapult/generator'

module Katapult
  module Generators
    class NavigationGenerator < Katapult::Generator

      MENU_BAR = 'app/views/layouts/_menu_bar.html.haml'

      desc 'Generate the navigation'
      source_root File.expand_path('../templates', __FILE__)


      def create_navigation
        template 'app/views/layouts/_navigation.html.haml'

        inject_into_file MENU_BAR, <<-CONTENT, after: /^\s+#navbar.*\n/
      = render 'layouts/navigation'
        CONTENT
      end

      private

      def navigation
        @element
      end

    end
  end
end
