Feature: Everything about user authentication

  Scenario: Login is required to visit the homepage
    When I go to the homepage
    Then I should see "Please sign in to continue" within the flash
      And I should be on the sign-in form


  Scenario: Login
    Given there is a user with the email "henry@example.com" and the password "password"

    When I go to the homepage
    Then I should be on the sign-in form
      And I should see "Please sign in"

    # Wrong email
    When I fill in "Email" with "nonsense"
      And I fill in "Password" with "password"
      And I press "Sign in"
    Then I should see "Bad email or password" within the flash
      And I should see "Please sign in"

    # Wrong password
    When I fill in "Email" with "admin@example.com"
      And I fill in "Password" with "wrong"
      And I press "Sign in"
    Then I should see "Bad email or password" within the flash
      And I should see "Please sign in"

    # Correct credentials
    When I fill in "Email" with "henry@example.com"
      And I fill in "Password" with "password"
      And I press "Sign in"
    Then I should be on the homepage


  Scenario: Logout
    Given there is a user
      And I am signed in as the user above

    When I follow "Sign out"
    Then I should be on the sign-in form

    # Logged out
    When I go to the homepage
    Then I should be on the sign-in form


  Scenario: Reset password as a signed-in user
    Given there is a user with the email "henry@example.com"
      And I sign in as the user above

    When I go to the homepage
      And I follow "henry@example.com" within the navbar
    Then I should be on the form for the user above

    When I fill in "Password" with "new-password"
      And I press "Save"
    Then I should be on the page for the user above

    When I follow "Sign out"
      And I fill in "Email" with "henry@example.com"
      And I fill in "Password" with "new-password"
      And I press "Sign in"
    Then I should be on the homepage


  Scenario: Reset password as a signed-out user
    Given there is a user with the email "henry@example.com"

    When I go to the sign-in form
      And I follow "Forgot password"
    Then I should be on the reset password page
      And I should see "Password Reset"

    When I fill in "Email" with "henry@example.com"
      And I press "Request instructions"
    Then an email should have been sent with:
      """
      From: system@example.com
      To: henry@example.com
      Subject: Change your password

      To reset your password, please follow this link:
      """

    When I follow the first link in the email
    Then I should be on the new password page for the user above
      And I should see "Reset Password"

    When I fill in "Choose password" with "new-password"
      And I press "Update password"
    Then I should see "Password successfully changed" within the flash
      And I should be on the homepage
