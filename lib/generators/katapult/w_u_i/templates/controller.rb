class <%= model_name(:classes) %>Controller < ApplicationController
<% if wui.find_action :index -%>

  def index
    <%= method_name(:load_collection) %>
  end
<% end -%>
<% if wui.find_action :show -%>

  def show
    <%= method_name(:load_object) %>
  end
<% end -%>
<% if wui.find_action :new -%>

  def new
    <%= method_name(:build) %>
  end
<% end -%>
<% if wui.find_action :create -%>

  def create
    <%= method_name(:build) %>
    <%= method_name(:save) %> or render :new
  end
<% end -%>
<% if wui.find_action :edit -%>

  def edit
    <%= method_name(:load_object) %>
    <%= method_name(:build) %>
  end
<% end -%>
<% if wui.find_action :update -%>

  def update
    <%= method_name(:load_object) %>
    <%= method_name(:build) %>
    <%= method_name(:save) %> or render :edit
  end
<% end -%>
<% if wui.find_action :destroy -%>

  def destroy
    <%= method_name(:load_object) %>
    <%= model_name(:ivar) %>.destroy
    redirect_to <%= wui.path(:index) %>
  end
<% end -%>
<% wui.custom_actions.each do |action|  -%>

  def <%= action.name %>
<% if action.member? -%>
    <%= method_name(:load_object) %>
  <%- unless action.get? -%>
    redirect_to <%= model_name(:ivar) %>
  <%- end -%>
<% elsif action.collection? -%>
    <%= method_name(:load_collection) %>
  <%- unless action.get? -%>
    redirect_to <%= wui.path(:index) %>
  <%- end -%>
<% end -%>
  end
<% end -%>

  private

  def <%= method_name(:load_collection) %>
    <%= model_name(:ivars) %> ||= <%= method_name(:scope) %>.to_a
  end

  def <%= method_name(:load_object) %>
    <%= model_name(:ivar) %> ||= <%= method_name(:scope) %>.find(params[:id])
  end

  def <%= method_name(:build) %>
    <%= model_name(:ivar) %> ||= <%= method_name(:scope) %>.build
    <%= model_name(:ivar) %>.attributes = <%= method_name(:params) %>
  end

  def <%= method_name(:save) %>
    if <%= model_name(:ivar) %>.save
      redirect_to <%= model_name(:ivar) %>
    end
  end

  def <%= method_name(:params) %>
    <%= method_name(:params) %> = params[:<%= model_name(:variable) %>]
    <%= method_name(:params) %> ? <%= method_name(:params) %>.permit(%i[<%= wui.model.attrs.map(&:name).join(' ') %>]) : {}
  end

  def <%= method_name(:scope) %>
    <%= model_name(:class) %>.scoped
  end

end
