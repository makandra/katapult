require 'wheelie/generator'

module Wheelie
  module Generators
    class ModelSpecsGenerator < Wheelie::Generator

      attr_accessor :model

      desc 'Generate model specs'

      check_class_collision
      source_root File.expand_path('../templates', __FILE__)


      def initialize(args = [], options = {}, config = {})
        extract_smuggled(Wheelie::Model, :model, args)
        super
      end

      def create_model_spec
        template 'model_spec.rb', spec_path
      end

      no_tasks do
        def attrs_with_default
          model.attrs.select{ |attr| attr.default != nil }
        end
      end

      private

      def spec_path
        File.join('spec', 'models', "#{file_name}_spec.rb")
      end

    end
  end
end
