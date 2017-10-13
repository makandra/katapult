Feature: <%= model.name(:humans).titleize %>

  Scenario: CRUD <%= model.name(:humans) %>
    Given I am on the list of <%= model.name(:variables) %>

    # create
    When I follow "Add <%= model.name(:human) %>"
<% model.attrs.each do |attr| -%>
  <%- if attr.assignable_values -%>
      And I select "<%= attr.test_value %>" from "<%= attr.name.humanize %>"
  <%- else -%>
    <%- case attr.type -%>
    <%- when :string, :email, :url, :integer, :money, :text, :password -%>
      And I fill in "<%= attr.name.humanize %>" with "<%= attr.test_value %>"
    <%- when :flag -%>
      And I check "<%= attr.name.humanize %>"
    <%- when :datetime -%>
      And I fill in "<%= attr.name.humanize %>" with "<%= attr.test_value.to_date %>"
    <%- end -%>
  <%- end -%>
<% end -%>
      And I press "Save"

    # read
    Then I should be on the page for the <%= model.name(:variable) %> above
<% model.attrs.each do |attr| -%>
  <%- case attr.type -%>
    <%- when :string, :email, :url, :integer, :money, :text -%>
      And I should see "<%= attr.test_value %>"
  <%- when :flag -%>
      And I should see "<%= attr.name.humanize %> Yes"
  <%- when :datetime -%>
      And I should see "<%= I18n.localize(attr.test_value.to_date) %>"
  <%- end -%>
<% end -%>

    # update
    When I follow "Edit"
    Then I should be on the form for the <%= model.name(:variable) %> above
<% model.attrs.each do |attr| -%>
  <%- if attr.assignable_values -%>
      And "<%= attr.test_value %>" should be selected for "<%= attr.name.humanize %>"
  <%- else -%>
    <%- case attr.type -%>
    <%- when :string, :email, :url, :integer, :money, :text -%>
      And the "<%= attr.name.humanize %>" field should contain "<%= attr.test_value %>"
    <%- when :flag -%>
      And the "<%= attr.name.humanize %>" checkbox should be checked
    <%- when :datetime -%>
      And the "<%= attr.name.humanize %>" field should contain "<%= attr.test_value.to_date %>"
    <%- end -%>
  <%- end -%>
<% end -%>

<% if model.label_attr -%>
    # destroy
    When I go to the list of <%= model.name(:variables) %>
    Then I should see "<%= model.label_attr.test_value %>"

    When I follow "Destroy <%= model.label_attr.test_value %>"
    Then I should be on the list of <%= model.name(:variables) %>
    But I should not see "<%= model.label_attr.test_value %>"
<% end -%>
