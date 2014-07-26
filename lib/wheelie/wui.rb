require 'wheelie/element'
require 'wheelie/action'
require 'generators/wheelie/w_u_i/w_u_i_generator'

module Wheelie
  class WUI < Element

    attr_accessor :model, :actions

    RAILS_ACTIONS = %w[ index show new create edit update destroy ]
    UnknownActionError = Class.new(StandardError)

    def initialize(*args)
      self.actions = []

      super
    end

    # Metamodel API
    def action(name, options = {})
      name = name.to_sym

      actions << Action.new(:new, options) if name == :create
      actions << Action.new(:edit, options) if name == :update
      actions << Action.new(name, options)
    end

    # Metamodel API
    def rails_actions(*actions)
      options = actions.extract_options!
      actions.each { |a| action(a, options) }
    end

    def model
      metamodel.get_model(@model)
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
      Generators::WUIGenerator.new(self).invoke_all
    end

  end
end
