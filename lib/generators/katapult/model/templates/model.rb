class <%= class_name %> < ApplicationRecord

<%- flag_attrs.each do |attr| -%>
  include DoesFlag[<%= attr.name(:symbol) %>, default: <%= attr.default %>]
<%- end -%>
<% has_manys.each do |model| -%>
  has_many <%= model.name(:symbols) %>
<% end -%>
<% belongs_tos.each do |model| -%>
  belongs_to <%= model.name(:symbol) %>, optional: true
<% end -%>
<%- if defaults.any? -%>

  has_defaults(<%= defaults %>)
<%- end -%>
<%- model.attrs.select(&:assignable_values).each do |attr|  -%>

  assignable_values_for :<%= attr.name(:variable).sub /_id$/, '' %>, <%= attr.options.slice(:allow_blank, :default) %> do
    <%= attr.assignable_values %>
  end
<%- end -%>

  def to_s
<% if model.label_attr? -%>
    <%= model.label_attr.name %>.to_s
<% else -%>
    "<%= model.name %>##{id}"
<% end -%>
  end

end
