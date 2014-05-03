module Wheelie
  module Generators
    class ModelGenerator < Rails::Generators::Base
      desc 'Generate a Model'
      argument :arguments, required: true, type: :array

      def generate_model
        generate 'rails:model', *arguments
      end

    end
  end
end
