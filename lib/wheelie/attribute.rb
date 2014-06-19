require 'wheelie/element'

module Wheelie
  class Attribute < Element

    attr_accessor :type, :default, :assignable_values, :allow_blank

    def initialize(*args)
      super
      self.type ||= :email if name.to_s =~ /email/
      self.type ||= :string
    end

    def flag?
      type == :flag
    end

    def has_defaults?
      default and not [flag?, assignable_values].any?
    end

    def to_s
      db_type = case type
      when :email, :url
        'string'
      when :flag
        'boolean'
      when :money
        'decimal{10,2}' # precision and scale options
      else
        type.to_s
      end

      name + ':' + db_type
    end

  end
end
