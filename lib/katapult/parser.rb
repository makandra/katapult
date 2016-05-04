# This class reads an application model file and turns it into an
# ApplicationModel instance.

require_relative 'application_model'
require 'katapult/model'
require 'katapult/wui'
require 'katapult/navigation'
require 'katapult/authentication'

module Katapult
  class Parser

    def initialize
      self.application_model = Katapult::ApplicationModel.new
    end

    def parse(path_to_app_model_file)
      instance_eval File.read(path_to_app_model_file), path_to_app_model_file

      application_model
    end

    def model(name, options = {}, &block)
      application_model.add_model Model.new(name, options, &block)
    end

    def wui(name, options = {}, &block)
      application_model.add_wui WUI.new(name, options, &block)
    end

    def navigation(name)
      application_model.set_navigation Navigation.new(name)
    end

    def authenticate(name, system_email:)
      application_model.set_authentication Authentication.new(name,
        system_email: system_email
      )
    end

    private

    attr_accessor :application_model

  end
end
