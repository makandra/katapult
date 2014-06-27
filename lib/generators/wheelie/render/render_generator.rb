module Wheelie
  class RenderGenerator < Rails::Generators::Base
    desc 'Render the Wheelie metamodel'
    
    argument :path, required: true, type: :string, description: 'The path to the metamodel file'

    def render_metamodel
      Wheelie::Metamodel.new(path).render
    end

    def migrate
      <<-`MIGRATE`
        bin/rake db:drop db:create db:migrate RAILS_ENV=development
        bin/rake db:drop db:create db:migrate RAILS_ENV=test
      MIGRATE
    end

  end
end
