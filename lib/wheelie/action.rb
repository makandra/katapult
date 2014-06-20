require 'wheelie/element'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inquiry'

module Wheelie
  class Action < Element

    attr_accessor :name, :options, :method, :scope

    def initialize(*args)

      super
    end

    delegate :post?, :get?, :put?, to: :method
    delegate :member?, :collection?, to: :scope

    def method
      @method.to_s.inquiry
    end

    def scope
      @scope.to_s.inquiry
    end

  end
end
