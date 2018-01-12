# Models a Rails model

require 'katapult/element'
require 'katapult/elements/attribute'
require 'generators/katapult/model/model_generator'

module Katapult
  class Model < Element

    UnknownAttributeError = Class.new(StandardError)
    MissingLabelAttributeError = Class.new(StandardError)

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
      options[:model] = self
      attrs << Attribute.new(attr_name, options)
    end

    # DSL
    def belongs_to(model_name)
      application_model.association name, belongs_to: model_name
    end


    def label_attr
      renderable_attrs.first.presence or raise MissingLabelAttributeError
    end

    def label_attr?
      label_attr.present?
    rescue MissingLabelAttributeError
      false
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

    def add_foreign_key_attrs(belongs_tos)
      belongs_tos.each do |other_model|
        attr "#{ other_model.name :variable }_id", type: :foreign_key,
          assignable_values: "#{ other_model.name(:class) }.all.to_a",
          allow_blank: true,
          associated_model: other_model
      end
    end

    def render
      Generators::ModelGenerator.new(self).invoke_all
    end

    private

    attr_accessor :_belongs_tos

  end
end
