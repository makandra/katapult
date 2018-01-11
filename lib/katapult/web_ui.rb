# Models a controller, including routes and views. Little more than a container
# class for the Attribute element.

require 'katapult/element'
require 'katapult/action'
require 'generators/katapult/web_ui/web_ui_generator'

module Katapult
  class WebUI < Element

    options :model
    attr_accessor :actions

    RAILS_ACTIONS = %w[ index show new create edit update destroy ]
    UnknownActionError = Class.new(StandardError)
    UnknownModelError = Class.new(StandardError)
    MissingLabelAttrError = Class.new(StandardError)

    def initialize(*args)
      self.actions = []

      super
    end

    # DSL
    def action(name, options = {})
      actions << Action.new(:new, options) if name.to_s == 'create'
      actions << Action.new(:edit, options) if name.to_s == 'update'

      actions << Action.new(name, options)
    end

    # DSL
    def crud
      %i(index show create update destroy).each &method(:action)
    end

    def crud_only?
      actions.map(&:name).sort == RAILS_ACTIONS.sort
    end

    def model
      model_name = @model || self.name
      application_model.get_model(model_name) or raise UnknownModelError,
        "Cannot find a model named #{model_name}"
    end

    def params
      model.attrs.map do |attr|
        attr.name :symbol
      end
    end

    def custom_actions
      actions.reject { |a| RAILS_ACTIONS.include? a.name }
    end

    def find_action(action_name)
      actions.find { |a| a.name == action_name.to_s }
    end

    def path(action, object_name = nil)
      unless action.is_a?(Action)
        not_found_message = "Unknown action '#{action}'"
        action = find_action(action) or raise UnknownActionError, not_found_message
      end

      member_path = "#{model.name(:variable)}_path"
      collection_path = "#{model.name(:variables)}_path"

      path = ''
      path << action.name << '_' unless %w[index show destroy].include?(action.name)
      path << (action.member? ? member_path : collection_path)
      path << "(#{object_name})" if object_name

      path
    end

    def model_name(kind = nil)
      model.name(kind)
    end

    def render
      validate!
      Generators::WebUIGenerator.new(self).invoke_all
    end

    private

    def validate!
      model.label_attr.present? or raise MissingLabelAttrError,
        'Cannot render a WebUI without a model with a label attribute'
    end

  end
end
