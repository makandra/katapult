module Wheelie
  class Names

    attr_accessor :model

    def initialize(model)
      self.model = model
    end

    def symbol
      ":#{variable}"
    end

    def variable
      model_name.underscore
    end

    def variables
      variable.pluralize
    end

    def ivar
      "@#{variable}"
    end

    def ivars
      "@#{variable.pluralize}"
    end

    def human_plural
      model_name.pluralize
    end

    def human_singular
      model_name
    end

    def class_name
      model_name.classify
    end

    private

    def model_name
      model.name.downcase
    end

  end
end
