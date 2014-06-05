module Wheelie
  class Element

    UnknownOptionError = Class.new(StandardError)

    private

    def set_attributes(options)
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
