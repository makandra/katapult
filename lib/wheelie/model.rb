require 'wheelie/element'
require 'wheelie/attribute'

module Wheelie
  class Model < Element

    attr_accessor :attrs

    def initialize(*args)
      self.attrs = []
      super
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

    def singular_name
      name.downcase
    end

    def render
      Rails::Generators.invoke('wheelie:model', [self])
    end

  end
end
