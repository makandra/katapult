module Wheelie
  class Generator < Rails::Generators::NamedBase

    private

    def render_partial(template_path, binding = nil)
      path = File.join(self.class.source_root, template_path)
      ERB.new(::File.binread(path), nil, '%').result(binding || self.binding)
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
