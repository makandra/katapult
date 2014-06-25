require 'wheelie/model'
require 'wheelie/wui'
require 'wheelie/reference'

module Wheelie
  class Metamodel

    attr_accessor :name, :models, :wuis

    def initialize(path_to_metamodel)
      self.models = []
      self.wuis = []
      Reference.instance.set_metamodel(self)

      instance_eval File.read(path_to_metamodel), path_to_metamodel
    end

    def render
      models.each &:render
      wuis.each &:render

      <<-`SYSTEM`
        bundle exec rake db:drop db:create db:migrate RAILS_ENV=development
        bundle exec rake db:drop db:create db:migrate RAILS_ENV=test
      SYSTEM
    end

    def metamodel(name)
      self.name = name

      yield self
    end

    def model(name, &block)
      models << Model.new(name, &block)
    end

    def wui(name, options = {}, &block)
      wuis << WUI.new(name, options, &block)
    end

  end
end
