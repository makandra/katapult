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
      name.underscore
    end

    def human_plural
      name.pluralize
    end

    def human_singular
      name
    end

    def class_name
      name.classify
    end

    private

    def name
      model.name.downcase
    end

  end
end
