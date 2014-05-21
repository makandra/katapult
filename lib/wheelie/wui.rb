module Wheelie
  class WUI

    attr_accessor :name

    def initialize(name)
      self.name = name

      yield(self) if block_given?
    end

    def render
      Rails::Generators.invoke('wheelie:w_u_i', [self])
    end

  end
end
