# This class serves as a global reference for elements in a metamodel.

require 'singleton'

module Wheelie
  class Reference
    include Singleton

    attr_accessor :metamodel

    def set_metamodel(metamodel)
      self.metamodel = metamodel
    end

    def model(name)
      metamodel.models.find do |model|
        model.name == name
      end
    end

    def wui(name)
      metamodel.wuis.find do |wui|
        wui.name == name
      end
    end

    def navigation(_ = nil)
      metamodel.nav
    end

  end
end
