# Models the main menu

require 'katapult/element'
require 'generators/katapult/navigation/navigation_generator'

module Katapult
  class Navigation < Element

    def web_uis
      application_model.web_uis
    end

    def links
      web_uis.each_with_object({}) do |web_ui, map|
        next unless web_ui.find_action(:index).present?

        label = web_ui.model_name :humans
        map[label] = web_ui.path(:index)
      end
    end

    def render(options = {})
      Generators::NavigationGenerator.new(self, options).invoke_all
    end

  end
end
