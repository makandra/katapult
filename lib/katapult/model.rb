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
      renderable_attrs.first
    end

    def db_fields
      attrs.reject(&:skip_db)
    end

    def renderable_attrs
      attrs.reject { |a| %w[plain_json json password].include? a.type.to_s }
    end

    def editable_attrs
      attrs.reject { |a| %w[plain_json json].include? a.type.to_s }
    end

    def render
      Generators::ModelGenerator.new(self).invoke_all
    end

  end
end
