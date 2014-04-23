require 'wheelie/metamodel'

module Wheelie
  class Renderer
    
    def initialize(path_to_metamodel)
      instance_eval File.read(path_to_metamodel), path_to_metamodel
    end
    
    def metamodel(name, &block)
      @metamodel = Metamodel.new(name)
      @metamodel.instance_eval(&block)
    end
    
    def render
      @metamodel.render
    end

  end
end
