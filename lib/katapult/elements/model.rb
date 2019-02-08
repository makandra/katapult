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
    def belongs_to(association_name, **options)
      options[:belonging_model_name] = name
      options[:owning_model_name] = options.delete(:model)

      application_model.association association_name, options
    end


    def label_attr
      renderable_attrs.first.presence or raise MissingLabelAttributeError,
        "Model #{name} is missing a label attribute"
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
      attrs.select &:renderable?
    end

    def editable_attrs
      attrs.select &:editable?
    end

    def required_attrs
      attrs.select &:required?
    end

    def add_foreign_key_attrs(belongs_to_associations)
      belongs_to_associations.each do |association|
        options = {
          type: :foreign_key,
          association: association,
        }

        unless association.polymorphic?
          owner = association.owning_models.first

          options[:assignable_values] = "#{ owner.name(:class) }.all.to_a"
          options[:allow_blank] = true
        end

        attr "#{ association.name :variable }_id", options
      end
    end

    def render(options = {})
      Generators::ModelGenerator.new(self, options).invoke_all
    end

    private

    attr_accessor :_belongs_tos

  end
end
