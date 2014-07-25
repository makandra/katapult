# The base class for all Wheelie elements to inherit from.

# Every Wheelie element has a name which is a String. All options passed will be
# mapped to attributes. Afterwards, the optional block will be yielded with
# self.

module Wheelie
  class Element

    UnknownOptionError = Class.new(StandardError)

    attr_accessor :name, :options
    attr_reader :metamodel

    def initialize(name, options = {})
      self.name = name.to_s
      self.options = options

      set_attributes(options)

      yield(self) if block_given?
    end

    def set_metamodel(metamodel)
      @metamodel = metamodel
    end

    private

    # Map options to attributes.
    # Example: set_attributes(foo: 123) sets the :foo attribute to 123 (via
    # #foo=) and raises UnknownOptionError if the attribute does not exist.
    def set_attributes(options)
      options.each_pair do |option, value|
        setter = "#{option}="

        if respond_to? setter
          send(setter, value)
        else
          raise UnknownOptionError, "#{self.class.name} does not support option #{option.inspect}."
        end
      end
    end

  end
end
