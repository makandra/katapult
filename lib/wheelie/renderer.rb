require 'wheelie/metamodel'

module Wheelie
  class Renderer
    
    def initialize(path_to_metamodel)
      @metamodel_path = path_to_metamodel
    end
    
    def go
      instance_eval File.read(@metamodel_path), @metamodel_path
    end
    
    def metamodel(name, &block)
      Metamodel.new(name).instance_eval(&block)
    end

  end
end
