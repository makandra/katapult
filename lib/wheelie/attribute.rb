require 'wheelie/element'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inquiry'
require 'zlib'

module Wheelie
  class Attribute < Element

    attr_accessor :type, :default, :assignable_values, :allow_blank

    UnknownTypeError = Class.new(StandardError)
    MissingOptionError = Class.new(StandardError)
    TYPES = %i(string email url integer money text markdown flag datetime)

    def initialize(*args)
      super

      self.type ||= :email if name.to_s =~ /email/
      self.type ||= :string

      validate
    end

    delegate :flag?, to: :type_inquiry

    def has_defaults?
      default and not [flag?, assignable_values].any?
    end

    def for_migration
      db_type = case type
      when :email, :url
        'string'
      when :flag
        'boolean'
      when :money
        'decimal{10,2}' # {precision,scale} = total digits, decimal places
      else
        type
      end

      "#{name}:#{db_type}"
    end

    def test_value
      if assignable_values
        assignable_values.first

      else
        case type
        when :string     then "#{name}-string"
        when :email      then "#{name}@wheelie.com"
        when :url        then "#{name}.wheelie.com"
        when :text       then "#{name}-text"

        # Deterministically generate a value from the attribute's name
        when :integer    then Zlib.crc32(name).modulo(1000)
        when :money      then Zlib.crc32(name).modulo(1000) / 100.0
        when :datetime   then Time.at(Zlib.crc32(name))
        end
      end
    end

    private

    def type_inquiry
      @type.to_s.inquiry
    end

    def validate
      TYPES.include?(type) or raise UnknownTypeError,
        "Attribute type :#{type} is not supported. Use one of #{TYPES.inspect}."

      if flag? and default.nil?
        raise MissingOptionError,
          "The :flag attribute '#{name}' requires a default (true or false)."
      end
    end

  end
end
