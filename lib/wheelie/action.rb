module Wheelie
  class Action

    attr_accessor :name

    def initialize(name, options)
      self.name = name.to_s
    end

  end
end
