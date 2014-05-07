module Wheelie
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase

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
        template 'model.rb', model_file_path
      end


      # model file modifications

      def write_assignable_values
        restricted_attrs = @model.attrs.select(&:assignable_values)

        if restricted_attrs.any?
          gem 'assignable_values'

          restricted_attrs.each do |attr|
            opts = attr.options.slice(:allow_blank, :default)
            assignable_values = <<-CODE
  assignable_values_for :#{attr.name}, #{opts} do
    #{attr.assignable_values}
  end
            CODE

            inject_into_class model_file_path, class_name, assignable_values
          end
        end
      end

      def write_traits
        flags = @model.attrs.select(&:flag?)

        if flags.any?
          template 'does_flag.rb', File.join(%w[app util shared does_flag.rb])

          flags.each do |attr|
            flag = ":#{attr.name}, default: #{attr.default}"
            flags_string = "  include DoesFlag[#{flag}]\n"

            inject_into_class model_file_path, class_name, flags_string
          end
        end
      end

      def write_attribute_defaults
        defaults = @model.has_defaults

        if defaults.any?
          defaults_string = "  has_defaults #{defaults}\n"
          inject_into_class model_file_path, class_name, defaults_string
        end
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

      def model_file_path
        File.join('app', 'models', "#{file_name}.rb")
      end

    end
  end
end
