class <%= class_name %> < ActiveRecord::Base
<%- flag_attrs.each do |attr| -%>
  include DoesFlag[<%= attr.name(:symbol) %>, default: <%= attr.default %>]
<%- end -%>
<%- if defaults.any? -%>
  has_defaults(<%= defaults %>)
<%- end -%>
<%- model.attrs.select(&:assignable_values).each do |attr|  -%>
  assignable_values_for :<%= attr.name %>, <%= attr.options.slice(:allow_blank, :default) %> do
    <%= attr.assignable_values %>
  end
<%- end -%>

  def to_s
<% if model.label_attr -%>
    <%= model.label_attr.name %>.to_s
<% else -%>
    "<%= model.name %>##{id}"
<% end -%>
  end
end
