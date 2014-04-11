module Wheelie
  class InstallGenerator < Rails::Generators::Base
    desc 'Install wheelie into a Rails app'
  
    def setup_lib
      create_file 'lib/wheelie/metamodel.rb', '# wheelie metamodel file'
    end

  end
end
