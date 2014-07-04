Feature: <%= model_name(:human_plural).titleize %>

  Scenario: CRUD <%= model_name(:human_plural) %>
    When I go to the list of <%= model_name(:variables) %>
      And I follow "Add <%= model_name(:variable) %>"
      And I press "Save"
    Then I should be on the page for the <%= model_name(:variable) %> above
