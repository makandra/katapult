module Wheelie
  class Routes

    attr_accessor :model

    def initialize(model)
      self.model = model
    end

    def index
      plural_path
    end

    def new
      "new_#{singular_path}"
    end

    def edit(variable)
      member :edit, variable
    end

    def show(variable)
      "#{singular_path}(#{variable})"
    end

    def destroy(variable)
      "#{singular_path}(#{variable})"
    end

    def member(action_name, variable)
      "#{action_name}_#{singular_path}(#{variable})"
    end

    def collection(action_name)
      "#{action_name}_#{plural_path}"
    end

    private

    def singular_path
      "#{model.name.underscore}_path"
    end

    def plural_path
      "#{model.name.underscore.pluralize}_path"
    end

  end
end
