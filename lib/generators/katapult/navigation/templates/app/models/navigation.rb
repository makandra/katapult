class Navigation
  include Navy::Description

  navigation :<%= name.downcase %> do
<% navigation.wuis.each do |wui| -%>
  <%- if wui.find_action(:index) -%>
    section <%= navigation.section_name(wui) %>, <%= wui.model_name(:humans).titlecase.inspect %>, <%= wui.path(:index) %>
  <%- end -%>
<% end -%>
  end

end
