require 'katapult/element'
require 'generators/katapult/navigation/navigation_generator'

module Katapult
  class Navigation < Element

    def wuis
      application_model.wuis
    end

    def section_name(wui)
      wui.model_name(:symbols)
    end

    def render
      Generators::NavigationGenerator.new(self).invoke_all
    end

  end
end
