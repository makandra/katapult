Feature: <%= model_name(:human_plural).titleize %>

  Scenario: CRUD <%= model_name(:human_plural) %>
    Given I am on the list of <%= model_name(:variables) %>

    # create
    When I follow "Add <%= model_name(:variable) %>"
<% model_attrs.each do |attr| -%>
  <%- case attr.type -%>
  <%- when 'string', 'email', 'url', 'integer', 'money' -%>
      And I fill in "<%= attr.name.titleize %>" with "<%= attr.test_value %>"
  <%- when 'flag' -%>
      And I check "<%= attr.name.titleize %>"
  <%- end -%>
<% end -%>
      And I press "Save"

    # read
    Then I should be on the page for the <%= model_name(:variable) %> above
<% model_attrs.each do |attr| -%>
  <%- case attr.type -%>
  <%- when 'string', 'email', 'url', 'integer', 'money' -%>
      And I should see "<%= attr.test_value %>"
  <%- when 'flag' -%>
      And I should see "<%= attr.name.titleize %> Yes"
  <%- end -%>
<% end -%>

    # update
    When I follow "Edit"
    Then I should be on the form for the <%= model_name(:variable) %> above
<% model_attrs.each do |attr| -%>
  <%- case attr.type -%>
  <%- when 'string', 'email', 'url', 'integer', 'money' -%>
      And the "<%= attr.name.titleize %>" field should contain "<%= attr.test_value %>"
  <%- when 'flag' -%>
      And the "<%= attr.name.titleize %>" checkbox should be checked
  <%- end -%>
<% end -%>

    # destroy
    When I go to the list of <%= model_name(:variables) %>
    Then I should see "<%= wui.model.label_attr.test_value %>"

    When I follow "Destroy"
    Then I should be on the list of <%= model_name(:variables) %>
      But I should not see "<%= wui.model.label_attr.test_value %>"
