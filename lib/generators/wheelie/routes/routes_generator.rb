module Wheelie
  module Generators
    class RoutesGenerator < Rails::Generators::NamedBase

      attr_accessor :metamodel

      desc 'Generate the Rails routes'

      source_root File.expand_path('../templates', __FILE__)

      def initialize(args = [], options = {}, config = {})
        extract_smuggled_object(args)

        super
      end

      def overwrite_routes_rb
        routes_path = File.join('config', 'routes.rb')

        remove_file routes_path
        template 'routes.rb', routes_path
      end

      private

      # Normally, generators don't take objects as argument. However, we need a
      # model object for generating it. Replace the model object with its name
      # before calling super, so the generator doesn't notice.
      def extract_smuggled_object(args)
        if args.first.is_a? Wheelie::Metamodel
          self.metamodel = args.shift
          args.unshift metamodel.name.underscore
        end
      end

    end
  end
end
