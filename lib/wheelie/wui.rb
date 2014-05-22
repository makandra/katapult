require 'wheelie/action'

module Wheelie
  class WUI

    attr_accessor :name, :actions

    RAILS_ACTIONS = %w[ index show new create edit update destroy ]
    RAILS_VIEW_ACTIONS = %w[ index show new edit ]

    def initialize(name)
      self.name = name
      self.actions = []

      yield(self) if block_given?
    end

    def action(name, options = {})
      name = name.to_s

      actions << Action.new(name, options)
      actions << Action.new('new', options) if name == 'create'
      actions << Action.new('edit', options) if name == 'update'
    end

    def rails_view_actions
      actions.select { |action| RAILS_VIEW_ACTIONS.include? action.name }
    end

    def custom_actions
      actions.reject { |action| RAILS_ACTIONS.include? action.name }
    end

    def has_action?(action_name)
      actions.collect(&:name).include? action_name.to_s
    end

    def render
      Rails::Generators.invoke 'wheelie:w_u_i', [ self, '--template_engine=haml' ]
    end

  end
end
