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

    def label_attr
      attrs.first
    end

    def render
      Generators::ModelGenerator.new(self).invoke_all
    end

  end
end
