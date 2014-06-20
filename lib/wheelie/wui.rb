require 'wheelie/element'
require 'wheelie/action'

module Wheelie
  class WUI < Element

    attr_accessor :model, :actions, :views

    RAILS_ACTIONS = %w[ index show new create edit update destroy ]
    RAILS_VIEW_ACTIONS = %w[ index show new edit ]

    def initialize(*args)
      self.actions = []

      super

      self.views ||= 'haml'
      self.model = Reference.instance.model(model) if model.is_a?(String)
    end

    def action(name, options = {})
      name = name.to_s

      actions << Action.new('new', options) if name == 'create'
      actions << Action.new('edit', options) if name == 'update'
      actions << Action.new(name, options)
    end

    def rails_view_actions
      actions.select { |action| RAILS_VIEW_ACTIONS.include? action.name }
    end

    def rails_actions
      actions.select { |action| RAILS_ACTIONS.include? action.name }
    end

    def custom_actions
      actions - rails_actions
    end

    def member_actions
      custom_actions.select(&:member?)
    end

    def collection_actions
      custom_actions.select(&:collection?)
    end

    def find_action(action_name)
      actions.find { |a| a.name == action_name.to_s }
    end

    def path(action, object_name = nil)
      action = find_action(action) unless action.is_a? Action

      member_path = "#{model.name(:variable)}_path"
      collection_path = "#{model.name(:variables)}_path"

      path = ''
      path << action.name << '_' unless %w[index show destroy].include?(action.name)
      path << (action.member? ? member_path : collection_path)
      path << "(#{object_name})" if object_name

      path
    end

    def render
      Rails::Generators.invoke 'wheelie:w_u_i', [ self, "--template_engine=#{views}" ]
    end

  end
end
