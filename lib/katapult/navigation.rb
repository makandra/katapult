# Models the main menu

require 'katapult/element'
require 'generators/katapult/navigation/navigation_generator'

module Katapult
  class Navigation < Element

    def wuis
      application_model.wuis
    end

    def links
      wuis.each_with_object({}) do |wui, map|
        next unless wui.find_action(:index).present?

        label = wui.model_name :humans
        map[label] = wui.path(:index)
      end
    end

    def render
      Generators::NavigationGenerator.new(self).invoke_all
    end

  end
end
