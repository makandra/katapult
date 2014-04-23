module Wheelie
  class Metamodel
    
    def initialize(path_to_metamodel)
      instance_eval File.read(path_to_metamodel), path_to_metamodel
    end
    
    def metamodel(name, &block)
      @name = name
      @models = []
      instance_eval(&block)
    end
  
    def model(name, &block)
      model = Model.new(name)
      model.instance_eval(&block) if block_given?
      @models << model
    end
    
    def render
      @models.each &:render
    end

  end
end
