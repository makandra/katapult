# Root of the internal representation of an application model file

module Katapult
  class ApplicationModel

    attr_reader :models, :web_uis, :navigation, :authentication

    def initialize
      @models = []
      @web_uis = []
    end

    def add_model(model)
      model.set_application_model(self)
      @models << model
    end

    def get_model(name)
      models.find { |m| m.name == name }
    end

    def add_web_ui(web_ui)
      web_ui.set_application_model(self)
      @web_uis << web_ui
    end

    def get_web_ui(name)
      web_uis.find { |w| w.name == name }
    end

    def set_navigation(navigation)
      navigation.set_application_model(self)
      @navigation = navigation
    end

    def set_authentication(auth)
      auth.set_application_model(self)
      auth.ensure_user_model_attributes_present
      @authentication = auth
    end

    # ---

    def render
      models.each &:render
      web_uis.each &:render
      navigation.render if navigation
      authentication.render if authentication
    end

  end
end
