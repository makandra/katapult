require 'wheelie/element'

module Wheelie
  class Navigation < Element

    attr_accessor :name

    def initialize(*args)
      super
    end

    def wuis
      Wheelie::Reference.instance.metamodel.wuis
    end

    def machine_name
      name.underscore
    end

    def render
      Rails::Generators.invoke('wheelie:navigation', [name, '--wheelie-model=navigation'])
    end

  end
end
