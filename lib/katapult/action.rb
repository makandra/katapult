# Models a controller action. To be used within the block of a WUI.

require 'katapult/element'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inquiry'

module Katapult
  class Action < Element

    options :method, :scope

    def initialize(*args)
      super

      self.scope ||= (name == 'index') ? :collection : :member
      set_method
    end

    delegate :post?, :get?, :put?, to: :method_inquiry
    delegate :member?, :collection?, to: :scope_inquiry

    private

    def method_inquiry
      @method.to_s.inquiry
    end

    def scope_inquiry
      @scope.to_s.inquiry
    end

    def set_method
      self.method ||= case name
      when 'create', 'update'
        :post
      when 'destroy'
        :delete
      else # index, show, new, edit + custom actions
        :get
      end
    end

  end
end
