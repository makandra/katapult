require 'wheelie/element'
require 'generators/wheelie/navigation/navigation_generator'

module Wheelie
  class Navigation < Element

    def wuis
      metamodel.wuis
    end

    def section_name(wui)
      wui.model_name(:symbols)
    end

    def render
      Generators::NavigationGenerator.new(self).invoke_all
    end

  end
end
