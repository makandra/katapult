class <%= controller_class_name %>Controller < ApplicationController
<% if wui.has_action? :index -%>

  def index
  end
<% end -%>
<% if wui.has_action? :show -%>

  def show
  end
<% end -%>
<% if wui.has_action? :new -%>

  def new
  end
<% end -%>
<% if wui.has_action? :create -%>

  def create
  end
<% end -%>
<% if wui.has_action? :edit -%>

  def edit
  end
<% end -%>
<% if wui.has_action? :update -%>

  def update
  end
<% end -%>
<% if wui.has_action? :destroy -%>

  def destroy
  end
<% end -%>
<% wui.custom_actions.each do |action|  -%>

  def <%= action.name %>
  end
<% end -%>

end
