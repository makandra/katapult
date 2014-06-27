require 'wheelie/generator'

module Wheelie
  module Generators
    class ModelSpecsGenerator < Wheelie::Generator

      attr_accessor :model

      desc 'Generate model specs'

      check_class_collision
      source_root File.expand_path('../templates', __FILE__)


      def create_model_spec
        template 'model_spec.rb', spec_path
      end

      no_tasks do
        def specable_attrs
          model.attrs.select do |attr|
            attr.assignable_values.present? or attr.default != nil
          end
        end

        def assignable_value_for(attr)
          attr.assignable_values.last
        end

        # Try to guess a value that is not assignable
        def unassignable_value_for(attr)
          assignable = assignable_value_for(attr)

          case assignable
          when Integer
            assignable += 1
          when String
            assignable += '-unassignable'
          else
            raise "Assignable values of type #{assignable.class.name} not supported"
          end
        end
      end

      private

      def spec_path
        File.join('spec', 'models', "#{file_name}_spec.rb")
      end

      def set_wheelie_model(model_object)
        self.model = model_object
      end

    end
  end
end
