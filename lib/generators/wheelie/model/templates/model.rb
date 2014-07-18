class <%= class_name %> < ActiveRecord::Base

  def to_s
<% if model.label_attr -%>
    <%= model.label_attr.name %>.to_s
<% else -%>
    "<%= model.name %>##{id}"
<% end -%>
  end
end
