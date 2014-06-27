require 'wheelie/element'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inquiry'

module Wheelie
  class Attribute < Element

    attr_accessor :type, :default, :assignable_values, :allow_blank

    def initialize(*args)
      super
      @type ||= :email if name.to_s =~ /email/
      @type ||= :string
    end

    delegate :flag?, to: :type

    def type
      @type.to_s.inquiry
    end

    def has_defaults?
      default and not [flag?, assignable_values].any?
    end

    def to_s
      db_type = case type
      when 'email', 'url'
        'string'
      when 'flag'
        'boolean'
      when 'money'
        'decimal{10,2}' # precision and scale options
      else
        type
      end

      name + ':' + db_type
    end

  end
end
