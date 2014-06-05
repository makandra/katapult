require 'wheelie/element'
require 'wheelie/action'

module Wheelie
  class WUI < Element

    attr_accessor :model, :actions

    RAILS_ACTIONS = %w[ index show new create edit update destroy ]
    RAILS_VIEW_ACTIONS = %w[ index show new edit ]

    def initialize(name, options = {}, &block)
      self.actions = []
      super(name, options, &block)
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

    def has_action?(action_name)
      actions.collect(&:name).include? action_name.to_s
    end

    def render
      Rails::Generators.invoke 'wheelie:w_u_i', [ self, '--template_engine=haml' ]
    end

  end
end
