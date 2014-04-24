require 'wheelie/driver'

module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie metamodel'
    
    RenderError = Class.new(StandardError)

    argument :path, required: true, type: :string, description: 'The path to the metamodel file'
    class_option :driver, default: 'makandra', type: :string, description: 'The driver used for rendering'

    def ensure_working_directory_clean
      unless `git status --porcelain`.empty?
        puts <<-MSG
ERROR: Cannot render when the working directory is dirty.
       Please stash or commit all changes before rendering.

        MSG

        raise RenderError.new 'working directory dirty'
      end
    end

    def render_metamodel
      Wheelie::Driver.new(options[:driver]).render(path)
    end

  end
end
