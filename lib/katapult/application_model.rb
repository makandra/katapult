# Root of the internal representation of an application model file

require 'katapult/elements/model'
require 'katapult/elements/web_ui'
require 'katapult/elements/navigation'
require 'katapult/elements/authentication'
require 'katapult/elements/association'

module Katapult
  class ApplicationModel

    NotFound = Class.new(StandardError)

    attr_reader :models, :web_uis, :navigation, :authentication, :associations

    def self.parse(application_model_string, path_to_model = '')
      new.tap do |model|
        model.instance_eval application_model_string, path_to_model
      end
    end

    def initialize
      @models = []
      @associations = []
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


    def association(name, options = {})
      options[:application_model] = self
      associations << Association.new(name, options)
    end

    def get_model!(name)
      models.find { |m| m.name == name } or raise NotFound,
        "Could not find a model named #{ name }"
    end

    def get_web_ui(name)
      web_uis.find { |w| w.name == name }
    end

    # Returns all models that `model_name` belongs_to
    def get_belongs_tos_for(model_name)
      associations.select { |a| a.name == model_name }.map(&:belongs_to_model)
    end

    # Returns all models that `model_name` has_many of
    def get_has_manys_for(model_name)
      associations.select { |a| a.belongs_to == model_name }.map(&:model)
    end

    def render
      prepare_render

      models.each &:render
      web_uis.each &:render
      navigation.render if navigation
      authentication.render if authentication
    end

    private

    def prepare_render
      authentication &.ensure_user_model_attributes_present
      models.each do |model|
        belongs_tos = get_belongs_tos_for(model.name)
        model.add_foreign_key_attrs(belongs_tos)
      end
    end

  end
end
