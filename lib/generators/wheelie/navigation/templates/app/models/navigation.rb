class Navigation
  include Navy::Description

  navigation :<%= name.downcase %> do
<% navigation.wuis.each do |wui| -%>
  <%- if wui.find_action(:index) -%>
    section <%= wui.model_name(:symbols) %>, <%= wui.model_name(:human_plural).titlecase.inspect %>, <%= wui.path(:index) %>
  <%- end -%>
<% end -%>
  end

end
