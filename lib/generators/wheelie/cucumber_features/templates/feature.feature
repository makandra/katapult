Feature: <%= model_name(:human_plural).titleize %>

  Scenario: CRUD <%= model_name(:human_plural) %>
    When I go to the list of <%= model_name(:variables) %>
      And I follow "Add car"
      And I press "Speichern"
    Then I should see "xxx"

    # When I follow "Firmen"
    # Then I should see "GigaCorp"
    #   And I should see "Aux"
    #
    # When I follow "GigaCorp"
    # Then I should be on the contact page for company "GigaCorp"
    #   And I should see "Keine Mitarbeiter bekannt"
    #
    # When I follow "Bearbeiten"
    # Then the "Kundennummer" field should contain "the customer number"
    #
    # When I fill in "Kundenkategorie" with "BGZ-33"
    #   And I fill in "Kommentar zur Kategorie" with "Für A hat's nicht gereicht"
    #   And I press "Speichern"
    # Then the "Kundenkategorie" field should contain "BGZ-33"
    #   And I should see "Für A hat's nicht gereicht"
    #
    # When I fill in "Rufnummer (1)" with "0123 - 45 67"
    #   And I select "Zentrale" from "company_phone1_type"
    #   And I press "Speichern"
    #   And I follow "Anzeigen"
    # Then I should see "Rufnummern"
    #   And I should see "Zentrale:"
