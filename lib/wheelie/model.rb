require 'wheelie/element'
require 'wheelie/attribute'

module Wheelie
  class Model < Element

    attr_accessor :attrs

    def initialize(*args)
      self.attrs = []

      super
    end

    def attr(attr_name, options = {})
      attrs << Attribute.new(attr_name, options)
    end

    def has_defaults
      {}.tap do |defaults|
        attrs.select(&:has_defaults?).each do |attr|
          defaults[attr.name.to_sym] = attr.default
        end
      end
    end

    def name(kind = nil)
      human_name = @name.downcase
      machine_name = @name.underscore

      case kind.to_s
      when 'symbol'       then ":#{machine_name}"
      when 'variable'     then machine_name
      when 'variables'    then machine_name.pluralize
      when 'ivar'         then "@#{machine_name}"
      when 'ivars'        then "@#{machine_name.pluralize}"
      when 'human_plural' then human_name.pluralize
      when 'human'        then human_name
      when 'class'        then machine_name.classify
      else
        @name
      end
    end

    def render
      Rails::Generators.invoke('wheelie:model', [self])
    end

  end
end
