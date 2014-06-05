  assignable_values_for :<%= attr.name %>, <%= attr.options.slice(:allow_blank, :default) %> do
    <%= attr.assignable_values %>
  end
