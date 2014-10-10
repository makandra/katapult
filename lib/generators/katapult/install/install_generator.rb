module Katapult
  class InstallGenerator < Rails::Generators::Base

    desc 'Install katapult into a Rails app'
    source_root File.expand_path('../templates', __FILE__)

    def setup_lib
      template 'lib/katapult/application_model.rb'
    end

  end
end
