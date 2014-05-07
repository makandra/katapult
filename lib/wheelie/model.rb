require 'wheelie/attribute'

module Wheelie
  class Model

    attr_accessor :name, :attrs

    def initialize(name)
      self.name = name
      self.attrs = []

      yield(self) if block_given?
    end

    def attr(attr_name, options = {})
      attrs << Attribute.new(attr_name, options)
    end

    def has_defaults
      {}.tap do |defaults|
        attrs.select(&:has_defaults?).each do |attr|
          defaults[attr.name.to_sym] = attr.default
        end
      end
    end

    def render
      Rails::Generators.invoke('wheelie:model', [self])
    end

  end
end
