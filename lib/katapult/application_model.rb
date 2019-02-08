# Root of the internal representation of an application model file

require 'katapult/elements/model'
require 'katapult/elements/web_ui'
require 'katapult/elements/navigation'
require 'katapult/elements/authentication'
require 'katapult/elements/association'

module Katapult
  class ApplicationModel

    NotFound = Class.new(StandardError)

    attr_reader :models, :web_uis, :nav, :authentication, :associations

    def self.parse(application_model_string, path_to_model = '')
      new.tap do |model|
        model.instance_eval application_model_string, path_to_model
        model.finalize_model
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
      @nav = Navigation.new(name, application_model: self)
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

    def get_model(name)
      models.find { |m| m.name == name }
    end

    def get_model!(name)
      get_model(name) or raise NotFound, "Could not find a model named #{ name }"
    end

    def get_web_ui(name)
      web_uis.find { |w| w.name == name }
    end

    def get_belongs_tos_for(model_name)
      associations.select { |a| a.belonging_model_name == model_name }
    end

    def get_has_manys_for(model_name)
      associations.select { |a| a.owning_model_names.include? model_name }
    end

    def finalize_model
      authentication &.ensure_user_model_attributes_present
      associations.each &:validate!
      models.each do |model|
        belongs_tos = get_belongs_tos_for(model.name)
        model.add_foreign_key_attrs(belongs_tos)
      end
    end

    def render(options = {})
      models.each { |m| m.render(options) }
      web_uis.each { |w| w.render(options) }
      nav.render(options) if nav
      authentication.render(options) if authentication
    end

  end
end
