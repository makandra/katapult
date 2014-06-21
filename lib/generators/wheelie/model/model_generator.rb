require 'wheelie/generator'

module Wheelie
  module Generators
    class ModelGenerator < Wheelie::Generator

      attr_accessor :model

      desc 'Generate a Model'
      argument :attrs, type: :array, default: []

      check_class_collision
      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled(Wheelie::Model, :model, args)
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
          restricted_attrs.each do |attr|
            inject_into_class model_file_path, class_name, render_partial('_assignable_values.rb', binding)
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

      def model_file_path
        File.join('app', 'models', "#{file_name}.rb")
      end

    end
  end
end
