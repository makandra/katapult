module Katapult
  class AppModelGenerator < Rails::Generators::Base

    desc 'Generate the default application model'
    source_root File.expand_path('../templates', __FILE__)

    def generate_application_model
      template 'lib/katapult/application_model.rb', filename
    end

    private

    def filename
      existing_models = Dir['lib/katapult/application_model*.rb']
      latest_filename = existing_models.sort.last

      if latest_filename
        latest_filename.sub /(\d)?(?=\.rb$)/ do
          $1 ? $1.to_i.next : 2 # When no counter present, continue with "2"
        end
      else
        'lib/katapult/application_model.rb' # Standard
      end
    end

  end
end
