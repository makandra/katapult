# Generate model specs.

require 'katapult/generator'

module Katapult
  module Generators
    class ModelSpecsGenerator < Katapult::Generator

      desc 'Generate model specs'

      check_class_collision
      source_root File.expand_path('../templates', __FILE__)


      def create_model_spec
        template 'model_spec.rb', File.join('spec', 'models', "#{file_name}_spec.rb")
      end

      no_tasks do
        def specable_attrs
          model.attrs.select do |attr|
            attr.assignable_values_as_list? or !attr.default.nil?
          end
        end

        def assignable_value_for(attr)
          attr.assignable_values.last
        end

        # Guess a value that is not assignable
        def unassignable_value_for(attr)
          case attr.type
          when :integer
            attr.assignable_values.max + 1
          when :string
            assignable_value_for(attr) + '-unassignable'
          else
            raise "Assignable values for :#{attr.type} attributes not supported"
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
