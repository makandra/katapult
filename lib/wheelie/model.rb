module Wheelie
  class Model

    def initialize(name)
      @name = name
      @string_attrs = []

      yield(self) if block_given?
    end

    def attr(name, options = {})
      @string_attrs << name.to_s
    end

    def render
      params = [@name]
      @string_attrs.each do |attr|
        params << (attr + ':string')
      end

      Rails::Generators.invoke('model', params)
    end

  end
end
