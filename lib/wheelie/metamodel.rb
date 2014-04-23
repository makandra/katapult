module Wheelie
  class Metamodel
    
    def initialize(name)
      @name = name
      @models = []
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
