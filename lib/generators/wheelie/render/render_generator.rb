require 'wheelie/driver'

module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie metamodel'
    
    argument :path, required: true, type: :string, description: 'The path to the metamodel file'
    class_option :driver, default: 'makandra', type: :string, description: 'The driver used for rendering'
  
    def render_metamodel
      Wheelie::Driver.new(options[:driver]).render(path)
    end

  end
end
