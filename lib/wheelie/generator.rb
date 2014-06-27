require 'rails/generators'
require 'wheelie/reference'

module Wheelie
  class Generator < Rails::Generators::NamedBase

    # This option is used to retrieve the Wheelie model object. Its value must
    # be a method on Wheelie::Reference, e.g. '--wheelie-model=model' expects
    # Reference.model(name) to be defined.
    class_option :wheelie_model

    def initialize(args = [], options = {}, config = {})
      super

      # Retrieve and set a Wheelie model object
      if self.options.wheelie_model
        model_object = Reference.instance.send(self.options.wheelie_model, args.first)
        set_wheelie_model(model_object)
      end
    end

    private

    def render_partial(template_path, given_binding = nil)
      path = File.join(self.class.source_root, template_path)
      ERB.new(::File.binread(path), nil, '%').result(given_binding || binding)
    end

    # Generators depending on a wheelie model must override this method in order
    # to get it set by the initializer
    def set_wheelie_model(object)
      raise NotImplementedError, <<-MESSAGE
#{self.class.name} does not override #set_wheelie_model

When passing the --wheelie-model option, the generator must override this
method in order to have the Wheelie model object set.
      MESSAGE
    end

    # Normally, generators don't take objects as argument. However, we need a
    # metamodel object for generating it. Replace the object with its name
    # before calling super, so the generator doesn't notice. Store the object
    # in the variable with the given name.
    #
    # Call this method in the #initialize method before #super.
    def extract_smuggled(klass, variable, args)
      if args.first.is_a?(klass)
        object = args.shift

        send "#{variable}=", object
        args.unshift object.name.underscore
      end
    end

  end
end
