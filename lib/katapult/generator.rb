# The base class for katapult element generators

require 'rails/generators'
require 'katapult/support/generator_goodies'

module Katapult
  class Generator < Rails::Generators::NamedBase
    include Katapult::GeneratorGoodies

    attr_accessor :element

    def initialize(element)
      self.element = element

      super([element.name], {}, {}) # args, opts, config
    end

    private

    def render_partial(template_path, given_binding = nil)
      path = File.join(self.class.source_root, template_path)
      ERB.new(::File.binread(path), nil, '%').result(given_binding || binding)
    end

  end
end
