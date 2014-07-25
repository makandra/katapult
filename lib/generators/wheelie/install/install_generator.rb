module Wheelie
  class InstallGenerator < Rails::Generators::Base
  
    desc 'Install wheelie into a Rails app'
    source_root File.expand_path('../templates', __FILE__)

    def setup_lib
      template 'lib/wheelie/metamodel.rb'
    end

  end
end
