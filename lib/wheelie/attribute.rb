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

    def for_migration
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

    def test_value
      case type
      when 'string'     then "#{name}-string"
      when 'email'      then "#{name}@wheelie.com"
      when 'url'        then "#{name}.wheelie.com"
      when 'integer'    then hash.abs.to_s[1..3]
      when 'money'      then hash.abs.to_s[1..5].to_f / 100.0
      end
    end

  end
end
