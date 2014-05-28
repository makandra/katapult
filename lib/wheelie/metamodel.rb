require 'wheelie/model'
require 'wheelie/wui'

module Wheelie
  class Metamodel

    attr_accessor :wuis, :name

    def initialize(path_to_metamodel)
      @models = []
      self.wuis = []

      instance_eval File.read(path_to_metamodel), path_to_metamodel
    end

    def render
      @models.each &:render
      wuis.each &:render
      Rails::Generators.invoke 'wheelie:routes', [self]
    end

    def metamodel(name)
      self.name = name

      yield self
    end

    def model(name, &block)
      @models << Model.new(name, &block)
    end

    def wui(name, &block)
      wuis << WUI.new(name, &block)
    end

  end
end
