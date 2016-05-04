# The katapult generator base class, slightly adapted from Rails generators.

require 'rails/generators'

module Katapult
  class Generator < Rails::Generators::NamedBase

    attr_accessor :element

    def initialize(element)
      self.element = element

      super([element.name], {}, {}) # args, opts, config
    end

    private

    def app_name
      File.basename(Dir.pwd)
    end

    def render_partial(template_path, given_binding = nil)
      path = File.join(self.class.source_root, template_path)
      ERB.new(::File.binread(path), nil, '%').result(given_binding || binding)
    end

    def run(*)
      Bundler.with_clean_env do
        super
      end
    end

  end
end
