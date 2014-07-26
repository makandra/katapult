require 'wheelie/element'
require 'wheelie/attribute'
require 'generators/wheelie/model/model_generator'

module Wheelie
  class Model < Element

    UnknownAttributeError = Class.new(StandardError)

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

    def label_attr
      @label_attr ||= attrs.first
    end

    def label_attr=(label_attr)
      attr = attrs.detect { |a| a.name == label_attr.to_s }

      @label_attr = attr or raise UnknownAttributeError,
        "Cannot set unknown attribute '#{label_attr}' as label attribute"
    end

    def render
      Generators::ModelGenerator.new(self).invoke_all
    end

  end
end
