require 'wheelie/element'

module Wheelie
  class Action < Element

    attr_accessor :name, :options, :method, :scope

    def member?
      scope.to_s == 'member'
    end

    def collection?
      scope.to_s == 'collection'
    end

  end
end
