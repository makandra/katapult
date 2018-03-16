# The base class for katapult element generators

require 'rails/generators'
require 'katapult/support/generator_goodies'

module Katapult
  class Generator < Rails::Generators::NamedBase
    include Katapult::GeneratorGoodies

    attr_accessor :element

    # @option :force (from Thor): Overwrite on conflict
    def initialize(element, options = {})
      self.element = element
      args = [element.name]
      config = {}

      super args, options, config
    end

    private

    def render_partial(template_path, given_binding = nil)
      path = File.join(self.class.source_root, template_path)
      ERB.new(::File.binread(path), nil, '%').result(given_binding || binding)
    end

    def generate(generator_name)
      args = []
      args << '--force' if options[:force]

      super generator_name, *args
    end

  end
end
