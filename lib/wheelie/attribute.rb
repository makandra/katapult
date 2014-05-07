module Wheelie
  class Attribute

    UnknownOptionError = Class.new(StandardError)

    attr_accessor :name, :type, :default

    def initialize(name, options)
      self.name = name.to_s
      self.type = :string

      set_attributes_from(options)
    end

    def flag?
      type == :flag
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

    private

    def set_attributes_from(options)
      options.each_pair do |option, value|
        setter = "#{option}="

        if respond_to? setter
          self.send(setter, value)
        else
          raise UnknownOptionError, "Option '#{option.inspect}' is not supported."
        end
      end
    end

  end
end
