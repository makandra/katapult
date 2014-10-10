# Models a Rails model.

require 'katapult/element'
require 'katapult/attribute'
require 'generators/katapult/model/model_generator'

module Katapult
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
