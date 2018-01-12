# Models a Rails model

require 'katapult/element'
require 'katapult/elements/attribute'
require 'generators/katapult/model/model_generator'

module Katapult
  class Model < Element

    UnknownAttributeError = Class.new(StandardError)

    attr_accessor :attrs, :belongs_tos, :has_manys

    def initialize(*args)
      self.attrs = []
      self._belongs_tos = []
      self.belongs_tos = []
      self.has_manys = []

      super
    end

    # DSL
    def attr(attr_name, options = {})
      attrs << Attribute.new(attr_name, options)
    end

    # DSL
    def belongs_to(model_name)

      # TODO create Association instead
      _belongs_tos << model_name.to_s
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

    # TODO obsolete
    def resolve_associations
      _belongs_tos.each do |model_name|
        model = application_model.get_model!(model_name)

        belongs_tos << model
        model.has_manys << self
      end
    end

    def render
      Generators::ModelGenerator.new(self).invoke_all
    end

    private

    attr_accessor :_belongs_tos

  end
end
