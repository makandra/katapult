# Models an association between models

require 'katapult/element'

module Katapult
  class Association < Element

    ModelMissingError = Class.new(StandardError)

    options :polymorphic, # List of associatable models
      :belonging_model_name,
      :owning_model_name # Optional, when differing from the association name

    def initialize(*args)
      super
      self.owning_model_name ||= name
    end

    def polymorphic?
      polymorphic.present?
    end

    def belonging_model
      application_model.get_model! belonging_model_name
    end

    def owning_model_names
      if polymorphic?
        polymorphic
      else
        [owning_model_name]
      end
    end

    # Models with "has_many <belonging_model_name>"
    # TODO render all in _form
    def owning_models
      owning_model_names.map do |owning_model_name|
        application_model.get_model owning_model_name
      end
    end

    def validate!
      owning_models.each do |model|
        model.present? or raise ModelMissingError,
          "Association '#{name}' in #{belonging_model.name(:class)} is missing an associated model"
      end
    end

  end
end
