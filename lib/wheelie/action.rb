module Wheelie
  class Action

    attr_accessor :name, :options, :method, :scope

    def initialize(name, options)
      self.name = name.to_s
      self.options = options

      set_attributes
    end

    def member?
      scope.to_s == 'member'
    end

    def collection?
      scope.to_s == 'collection'
    end

    private

    def set_attributes
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
