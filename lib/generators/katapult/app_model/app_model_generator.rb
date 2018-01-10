module Katapult
  class AppModelGenerator < Rails::Generators::Base

    desc 'Generate the default application model'
    source_root File.expand_path('../templates', __FILE__)

    def generate_application_model
      template 'lib/katapult/application_model.rb'
    end

  end
end
