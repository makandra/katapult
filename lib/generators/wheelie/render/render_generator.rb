module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie metamodel'
    
    class_option :path, type: :string, required: true, description: 'The path to the metamodel file'
  
    def render_metamodel
      Wheelie::Metamodel.new(options[:path]).render
    end

  end
end
