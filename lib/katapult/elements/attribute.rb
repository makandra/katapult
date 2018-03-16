# Models a model attribute. To be used within the block of a model element.

require 'katapult/element'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inquiry'
require 'zlib'

module Katapult
  class Attribute < Element

    options :type, :default, :assignable_values, :allow_blank, :skip_db
    attr_accessor :model, :associated_model

    UnknownTypeError = Class.new(StandardError)
    MissingOptionError = Class.new(StandardError)
    TYPES = %i[string email password url integer money text flag datetime json
      plain_json foreign_key]

    def initialize(*args)
      super

      self.type ||= :email if name.to_s =~ /email/
      self.type ||= :password if name.to_s =~ /password/
      self.type ||= :string

      validate!
    end

    delegate :flag?, to: :type_inquiry

    def has_defaults?
      !default.nil? and not [flag?, assignable_values].any?
    end

    def renderable?
      %i[plain_json json password].exclude? type
    end

    def editable?
      %i[plain_json json].exclude? type
    end

    def required?
      if assignable_values.present?
        default.blank? && allow_blank.blank?
      else
        false
      end
    end

    def for_migration
      db_type = case type
      when :email, :url, :password then 'string'
      when :flag then 'boolean'
      when :money then 'decimal{10,2}' # {precision,scale} = total digits, decimal places
      when :json then 'jsonb' # Indexable JSON
      when :plain_json then 'json' # Only use this if you need to
      when :foreign_key then 'integer'
      else type end

      "#{name}:#{db_type}"
    end

    def test_value
      if type == :foreign_key
        associated_model.label_attr.test_value
      elsif assignable_values
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

    def assignable_values_as_list?
      assignable_values.try(:to_a).present?
    end

    private

    def type_inquiry
      @type.to_s.inquiry
    end

    def validate!
      TYPES.include?(type) or raise UnknownTypeError,
        "Attribute type :#{type} is not supported. Use one of #{TYPES.inspect}."

      if flag? and default.nil?
        raise MissingOptionError,
          "The :flag attribute '#{name}' requires a default (true or false)."
      end
    end

  end
end
