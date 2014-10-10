class <%= controller_class_name %>Controller < ApplicationController
<% wui.actions.each do |action|  -%>

  def <%= action.name %>
  end
<% end -%>

end
