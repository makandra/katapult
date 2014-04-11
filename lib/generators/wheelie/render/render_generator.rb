module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie metamodel'
  
    def render_metamodel
      Wheelie::Renderer.new(File.join %w[lib wheelie metamodel.rb]).go
    end

  end
end
