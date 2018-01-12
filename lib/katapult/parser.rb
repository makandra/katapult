# This class reads an application model file and turns it into an
# ApplicationModel instance

require_relative 'application_model'
require 'katapult/elements/model'
require 'katapult/elements/web_ui'
require 'katapult/elements/navigation'
require 'katapult/elements/authentication'

module Katapult
  class Parser

    def initialize
      self.application_model = Katapult::ApplicationModel.new
    end

    def parse(application_model_string, path_to_model = '')
      instance_eval application_model_string, path_to_model

      application_model
    end

    def model(name, &block)
      application_model.add_model Model.new(name, &block)
    end

    def web_ui(name, options = {}, &block)
      application_model.add_web_ui WebUI.new(name, options, &block)
    end

    # A shortcut to create a #model together with a default #web_ui with CRUD
    # actions
    def crud(name, &block)
      application_model.add_model Model.new(name, &block)
      application_model.add_web_ui WebUI.new(name, &:crud)
    end

    def navigation(name = :main)
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
