Rails.application.routes.draw do
<% metamodel.wuis.each do |wui| -%>

  resources :<%= wui.name %>, only: <%= wui.rails_actions.map(&:name).map(&:to_sym) %> do

  end
<% end -%>

end
