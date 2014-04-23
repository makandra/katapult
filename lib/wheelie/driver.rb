module Wheelie
  class Driver
    
    def initialize(driver_name)
      @driver_name = driver_name
      
      require_metamodel
    end
    
    def render(path)
      metamodel.new(path).render
    end
    
    private
    
    def metamodel
      @metamodel ||= begin
        constant_name = Wheelie::Driver.constants.find { |c| c.to_s.downcase == @driver_name.classify.downcase }
        Wheelie::Driver.const_get(constant_name).const_get('Metamodel')
      end
    end
    
    def require_metamodel
      # search gem drivers
      require File.join(Wheelie.driver_root, @driver_name, 'metamodel')
    rescue LoadError
      # search app drivers
      require File.join(Rails.root, 'lib', 'wheelie', 'drivers', @driver_name, 'metamodel')
    end

  end
end
