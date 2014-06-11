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
      "edit_#{singular_path}(#{variable})"
    end

    def show(variable)
      "#{singular_path}(#{variable})"
    end

    def destroy(variable)
      "#{singular_path}(#{variable})"
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
