module Wheelie
  class Metamodel
    
    def initialize(name)
      @name = name
    end
  
    def model(name)
      Rails::Generators.invoke('model', [name]) # Rails generator
    end

  end
end
