require 'wheelie/model'

module Wheelie
  class Metamodel

    def initialize(path_to_metamodel)
      @models = []
      instance_eval File.read(path_to_metamodel), path_to_metamodel
    end

    def render
      @models.each &:render
    end

    def metamodel(name)
      @name = name

      yield self
    end

    def model(name, &block)
      @models << Model.new(name, &block)
    end

  end
end
