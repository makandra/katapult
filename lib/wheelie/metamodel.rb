# Internal representation of a metamodel file.

module Wheelie
  class Metamodel

    attr_reader :models, :wuis, :navigation, :home_wui

    def initialize
      @models = []
      @wuis = []
    end

    def add_model(model)
      model.set_metamodel(self)
      @models << model
    end

    def get_model(name)
      models.find { |m| m.name == name }
    end

    def add_wui(wui)
      wui.set_metamodel(self)
      @wuis << wui
    end

    def get_wui(name)
      wuis.find { |w| w.name == name }
    end

    def set_navigation(navigation)
      navigation.set_metamodel(self)
      @navigation = navigation
    end

    def set_home_wui(wui)
      @home_wui = wui
    end

    # ---

    def render
      models.each &:render
      wuis.each &:render
      navigation.render if navigation
    end

  end
end
