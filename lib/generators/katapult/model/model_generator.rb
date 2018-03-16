# Generate a Rails model, including migration and spec.

require 'katapult/generator'
require 'generators/katapult/model_specs/model_specs_generator'

module Katapult
  module Generators
    class ModelGenerator < Katapult::Generator

      desc 'Generate a Rails Model'

      check_class_collision
      source_root File.expand_path('../templates', __FILE__)


      def create_migration_file
        migration_name = "create_#{table_name}"
        migration_attributes = model.db_fields.map(&:for_migration)

        args = [migration_name] + migration_attributes
        options = { timestamps: true, force: true }
        invoke 'active_record:migration', args, options
      end

      def create_model_file
        template 'model.rb', File.join('app', 'models', "#{file_name}.rb")
      end

      def write_traits
        template 'app/models/shared/does_flag.rb' if flag_attrs.any?
      end

      def write_factory
        factory = "factory #{ model.name(:symbol) }"
        factories_file = 'spec/factories/factories.rb'
        # Can happen in multiple transformation runs with authentication
        return if file_contains?(factories_file, factory)

        insert_into_file factories_file, <<-FACTORY, before: /end\n\z/
  #{factory}

        FACTORY
      end

      def generate_unit_tests
        Generators::ModelSpecsGenerator.new(model, options).invoke_all
      end

      no_commands do
        def belongs_tos
          model.application_model.get_belongs_tos_for model.name
        end

        def has_manys
          model.application_model.get_has_manys_for model.name
        end

        def flag_attrs
          model.attrs.select(&:flag?)
        end

        def defaults
          {}.tap do |defaults|
            model.attrs.select(&:has_defaults?).each do |attr|
              defaults[attr.name.to_sym] = attr.default
            end
          end
        end
      end

      private

      def model
        @element
      end

    end
  end
end
