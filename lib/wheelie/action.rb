require 'wheelie/element'

module Wheelie
  class Action < Element

    attr_accessor :name, :options, :method, :scope

    def initialize(name, options)
      self.name = name.to_s
      self.options = options

      set_attributes(options)
    end

    def member?
      scope.to_s == 'member'
    end

    def collection?
      scope.to_s == 'collection'
    end

  end
end
