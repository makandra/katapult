class <%= model_name(:classes) %>Controller < ApplicationController
<% if web_ui.find_action :index -%>

  def index
    <%= method_name(:load_collection) %>
  end
<% end -%>
<% if web_ui.find_action :show -%>

  def show
    <%= method_name(:load_object) %>
  end
<% end -%>
<% if web_ui.find_action :new -%>

  def new
    <%= method_name(:build) %>
  end
<% end -%>
<% if web_ui.find_action :create -%>

  def create
    <%= method_name(:build) %>
    <%= method_name(:save) %>
  end
<% end -%>
<% if web_ui.find_action :edit -%>

  def edit
    <%= method_name(:load_object) %>
    <%= method_name(:build) %>
  end
<% end -%>
<% if web_ui.find_action :update -%>

  def update
    <%= method_name(:load_object) %>
    <%= method_name(:build) %>
    <%= method_name(:save) %>
  end
<% end -%>
<% if web_ui.find_action :destroy -%>

  def destroy
    <%= method_name(:load_object) %>
    <%= model_name(:ivar) %>.destroy
    redirect_to <%= web_ui.path(:index) %>
  end
<% end -%>
<% web_ui.custom_actions.each do |action|  -%>

  def <%= action.name %>
<% if action.member? -%>
    <%= method_name(:load_object) %>
  <%- unless action.get? -%>
    redirect_to <%= model_name(:ivar) %>
  <%- end -%>
<% elsif action.collection? -%>
    <%= method_name(:load_collection) %>
  <%- unless action.get? -%>
    redirect_to <%= web_ui.path(:index) %>
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
    <%= model_name(:ivar) %> ||= <%= method_name(:scope) %>.new
    <%= model_name(:ivar) %>.attributes = <%= method_name(:params) %>
  end

  def <%= method_name(:save) %>
    if <%= model_name(:ivar) %>.save
      redirect_to <%= model_name(:ivar) %>
    else
      action = <%= model_name(:ivar) %>.new_record? ? 'new' : 'edit'
      render action, status: :unprocessable_entity
    end
  end

  def <%= method_name(:params) %>
    <%= method_name(:params) %> = params[:<%= model_name(:variable) %>]
    return {} if <%= method_name(:params) %>.blank?

    <%= method_name(:params) %>.permit(
      <%= web_ui.params.join(",\n      ") %>,
    )
  end

  def <%= method_name(:scope) %>
    <%= model_name(:class) %>.scoped
  end

end
