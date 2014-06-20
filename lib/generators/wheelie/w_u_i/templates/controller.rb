class <%= controller_class_name %>Controller < ApplicationController
<% if wui.has_action? :index -%>

  def index
    <%= method_name(:load_collection) %>
  end
<% end -%>
<% if wui.has_action? :show -%>

  def show
    <%= method_name(:load_object) %>
  end
<% end -%>
<% if wui.has_action? :new -%>

  def new
    <%= method_name(:build) %>
  end
<% end -%>
<% if wui.has_action? :create -%>

  def create
    <%= method_name(:build) %>
    <%= method_name(:save) %> or render :new
  end
<% end -%>
<% if wui.has_action? :edit -%>

  def edit
    <%= method_name(:load_object) %>
    <%= method_name(:build) %>
  end
<% end -%>
<% if wui.has_action? :update -%>

  def update
    <%= method_name(:load_object) %>
    <%= method_name(:build) %>
    <%= method_name(:save) %> or render :edit
  end
<% end -%>
<% if wui.has_action? :destroy -%>

  def destroy
    <%= method_name(:load_object) %>
    <%= names.ivar %>.destroy
    redirect_to <%= routes.index %>
  end
<% end -%>
<% wui.custom_actions.each do |action|  -%>

  def <%= action.name %>
<% if action.member? -%>
    <%= method_name(:load_object) %>
  <%- if action.post? -%>
    redirect_to <%= names.ivar %>
  <%- end -%>
<% elsif action.collection? -%>
    <%= method_name(:load_collection) %>
<% end -%>
  end
<% end -%>

  private

  def <%= method_name(:load_collection) %>
    <%= names.ivars %> ||= <%= method_name(:scope) %>.to_a
  end

  def <%= method_name(:load_object) %>
    <%= names.ivar %> ||= <%= method_name(:scope) %>.find(params[:id])
  end

  def <%= method_name(:build) %>
    <%= names.ivar %> ||= <%= method_name(:scope) %>.build
    <%= names.ivar %>.attributes = <%= method_name(:params) %>
  end

  def <%= method_name(:save) %>
    if <%= names.ivar %>.save
      redirect_to <%= names.ivar %>
    end
  end

  def <%= method_name(:params) %>
    <%= method_name(:params) %> = params[:<%= names.variable %>] || {}
    <%= method_name(:params) %>.permit(<%= wui.model.attrs.map(&:name).map(&:to_sym) %>)
  end

  def <%= method_name(:scope) %>
    <%= names.class_name %>.scoped
  end

end
