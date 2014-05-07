module Wheelie
  module Generators
    class ModelGenerator < Rails::Generators::Base
      desc 'Generate a Model'
      argument :attrs, type: :array, default: []
      
      check_class_collision
      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled_object(args)

        super
      end

      def create_migration_file
        migration_name = "create_#{table_name}"
        migration_attributes = @model.attrs.map(&:to_s)

        args = [migration_name] + migration_attributes
        options = { :timestamps => true }
        invoke 'active_record:migration', args, options
      end
      
      def create_model_file
        template 'model.rb', File.join('app', 'models', "#{file_name}.rb")
      end
      
      private
      
      # Normally, generators don't take objects as argument. However, we need a
      # model object for generating it. Replace the model object with its name
      # before calling super, so the generator doesn't notice.
      def extract_smuggled_object(args)
        if args.first.is_a? Wheelie::Model
          @model = args.shift
          args.unshift @model.name.underscore
        end
      end

    end
  end
end
