module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie metamodel'
    
    argument :path, required: true, type: :string, description: 'The path to the metamodel file'

    def render_metamodel
      Wheelie::Metamodel.new(path).render
    end

  end
end
