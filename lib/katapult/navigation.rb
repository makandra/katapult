# Models the main menu

require 'katapult/element'
require 'generators/katapult/navigation/navigation_generator'

module Katapult
  class Navigation < Element

    def wuis
      application_model.wuis
    end

    def render
      Generators::NavigationGenerator.new(self).invoke_all
    end

  end
end
