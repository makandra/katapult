module Katapult
  class TemplatesGenerator < Rails::Generators::Base

    desc 'Copy Katapult templates to the target application'
    source_root File.expand_path('..', __dir__) # lib/generators/katapult

    def copy_view_templates
      copy_generator_templates 'views', %w[
        _form.haml
        edit.haml
        index.haml
        new.haml
        show.haml
      ]
    end

    def copy_controller_template
      copy_generator_templates 'web_ui', 'controller.rb'
    end

    private

    # file_list should contain paths relative the the respective generator
    # template root
    def copy_generator_templates(generator_name, file_list)
      Array(file_list).each do |filename|
        source = File.join generator_name, 'templates', filename
        destination = File.join 'lib/templates/katapult', generator_name, filename

        copy_file source, destination
      end
    end

  end
end
