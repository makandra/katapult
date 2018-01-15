# Root of the internal representation of an application model file

require 'katapult/elements/model'
require 'katapult/elements/web_ui'
require 'katapult/elements/navigation'
require 'katapult/elements/authentication'

module Katapult
  class ApplicationModel

    NotFound = Class.new(StandardError)

    attr_reader :models, :web_uis, :navigation, :authentication

    def self.parse(application_model_string, path_to_model = '')
      new.tap do |model|
        model.instance_eval application_model_string, path_to_model
      end
    end

    def initialize
      @models = []
      @web_uis = []
    end

    # DSL
    def model(name, &block)
      models << Model.new(name, application_model: self, &block)
    end

    # DSL
    def web_ui(name, options = {}, &block)
      options[:application_model] = self
      web_uis << WebUI.new(name, options, &block)
    end

    # DSL
    def navigation(name = :main)
      @navigation = Navigation.new(name, application_model: self)
    end

    # DSL
    def authenticate(user_model_name, system_email:)
      @authentication = Authentication.new(user_model_name,
        system_email: system_email, application_model: self)
    end

    # DSL
    def crud(name, &block)
      model name, &block
      web_ui name, &:crud
    end


    def get_model(name)
      models.find { |m| m.name == name }
    end

    def get_model!(name)
      get_model(name) or raise NotFound,
        "Could not find a model named #{ name }"
    end

    def get_web_ui(name)
      web_uis.find { |w| w.name == name }
    end

    def render
      models.each &:render
      web_uis.each &:render
      navigation.render if navigation
      authentication.render if authentication
    end

  end
end
