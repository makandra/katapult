# Models a model attribute. To be used within the block of a model element.

require 'katapult/element'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inquiry'
require 'zlib'

module Katapult
  class Attribute < Element

    options :type, :default, :assignable_values, :allow_blank, :skip_db

    UnknownTypeError = Class.new(StandardError)
    MissingOptionError = Class.new(StandardError)
    TYPES = %i(string email password url integer money text flag datetime json plain_json)

    def initialize(*args)
      super

      self.type ||= :email if name.to_s =~ /email/
      self.type ||= :password if name.to_s =~ /password/
      self.type ||= :string

      validate
    end

    delegate :flag?, to: :type_inquiry

    def has_defaults?
      default and not [flag?, assignable_values].any?
    end

    def for_migration
      db_type = case type
      when :email, :url, :password then 'string'
      when :flag then 'boolean'
      when :money then 'decimal{10,2}' # {precision,scale} = total digits, decimal places
      when :json then 'jsonb' # Indexable JSON
      when :plain_json then 'json' # Only use this if you need to
      else type end

      "#{name}:#{db_type}"
    end

    def test_value
      if assignable_values
        assignable_values.first

      else
        case type
        when :string     then "#{name}-string"
        when :password   then "#{name}-password"
        when :email      then "#{name}@example.com"
        when :url        then "#{name}.example.com"
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
