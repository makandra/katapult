class <%= controller_class_name %>Controller < ApplicationController
<% if wui.has_action? :index -%>

  def index
    load_collection
  end
<% end -%>
<% if wui.has_action? :show -%>

  def show
    load_object
  end
<% end -%>
<% if wui.has_action? :new -%>

  def new
    build_object
  end
<% end -%>
<% if wui.has_action? :create -%>

  def create
    build_object
  end
<% end -%>
<% if wui.has_action? :edit -%>

  def edit
    load_object
  end
<% end -%>
<% if wui.has_action? :update -%>

  def update
    load_object
  end
<% end -%>
<% if wui.has_action? :destroy -%>

  def destroy
    load_object
  end
<% end -%>
<% wui.custom_actions.each do |action|  -%>

  def <%= action.name %>
<% if action.member? -%>
    load_object
<% elsif action.collection? -%>
    load_collection
<% end -%>
  end
<% end -%>

  private

  def build_object
    @object ||= <%= wui.model.name %>.build
    @object.attributes = params[:<%= wui.model.singular_name %>]
  end

  def load_object
    @object ||= <%= wui.model.name %>.find(params[:id])
  end

  def load_collection
    @collection ||= <%= wui.model.name %>.all
  end

end
