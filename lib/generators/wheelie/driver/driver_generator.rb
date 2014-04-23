module Wheelie
  class DriverGenerator < Rails::Generators::Base
    argument :target, type: :string, required: true
    class_option :source, type: :string, required: true

    desc 'Locally generate a driver'
    source_root Wheelie.driver_root
    
    def copy_driver_to_target
      directory options[:source], target_path
    end
    
    def rename_module_in_new_driver
      Dir.glob(File.join(target_path, '*.rb')) do |file|
        gsub_file file, /module #{ options[:source].classify }/ do
          'module ' + target.classify
        end
      end
    end
    
    private
    
    def target_path
      File.join(%w[lib wheelie drivers] << target)
    end

  end
end
