#@announce-output
#@announce-stderr
Feature: Add authentication to an application

  Background:
    Given a new Rails application with Katapult basics installed


  Scenario: Authenticate with the user model
    When I write to "lib/katapult/application_model.rb" with:
      """
      model 'user'
      web_ui('user', &:crud)
      authenticate 'user', system_email: 'system@example.com'
      """
    And I successfully transform the application model including migrations
    Then the file "Gemfile" should contain "gem 'clearance'"
    And the file "app/controllers/application_controller.rb" should contain:
      """
        include Clearance::Controller

        before_action :require_login
      """
    And the file "app/controllers/passwords_controller.rb" should contain exactly:
      """
      class PasswordsController < Clearance::PasswordsController

        def update
          @user = find_user_for_update

          if @user.update_password password_reset_params
            sign_in @user
            flash[:notice] = 'Password successfully changed' # <<- added
            redirect_to url_after_update
          else
            flash_failure_after_update
            render template: 'passwords/edit'
          end
        end

      end
      """
    And the file "app/controllers/users_controller.rb" should match /permit.*email.*password/
    And the file "app/views/layouts/_menu_bar.html.haml" should contain:
      """
            = render 'layouts/current_user' if signed_in?
      """
    And the file "app/views/layouts/_current_user.html.haml" should contain:
    """
    %ul.nav.navbar-nav.navbar-right
      %li.dropdown
        = link_to edit_user_path(current_user), data: { toggle: 'dropdown' } do
          Hello,
          = current_user
          %span.caret

        %ul.dropdown-menu
          %li= link_to 'Edit profile', edit_user_path(current_user)
          %li.divider
          %li= link_to 'Sign out', sign_out_path, method: :delete, class: 'navbar-logout'
      """
    And the file "app/views/users/_form.html.haml" should contain:
      """
        .form-group
          = form.label :email
          = form.email_field :email
      """
    And the file "app/views/users/_form.html.haml" should contain:
      """
        .form-group
          = form.label :password
          = form.password_field :password
      """
    And the file "app/views/clearance_mailer/change_password.html.haml" should contain exactly:
      """
      %p
        To reset your password, please follow this link:

      %p
        = link_to 'Change password',
          edit_user_password_url(@user, token: @user.confirmation_token.html_safe)

      """
    And the file "app/views/clearance_mailer/change_password.text.erb" should contain exactly:
      """
      To reset your password, please follow this link:

      <%= edit_user_password_url(@user, token: @user.confirmation_token.html_safe) %>
      """
    And the file "app/views/passwords/create.html.haml" should contain exactly:
      """
      .row
        .col-md-4.col-md-offset-4

          %h1
            Password Reset Instructions Sent

          %p
            We've sent you an email with instructions on how to reset your password.

          %p
            = link_to 'Back to sign-in form', sign_in_path, class: 'btn btn-primary'
      """
    And the file "app/views/passwords/edit.html.haml" should contain exactly:
      """
      .row
        .col-md-4.col-md-offset-4

          %h1
            Reset Password

          = form_for :password_reset,
            url: user_password_path(@user, token: @user.confirmation_token),
            html: { method: :put } do |form|

            .form-group
              = form.label :password
              = form.password_field :password, class: 'form-control',
                placeholder: 'New password'

            = form.submit 'Update password', class: 'btn btn-primary'
      """
    And the file "app/views/passwords/new.html.haml" should contain exactly:
      """
      .row
        .col-md-4.col-md-offset-4

          %h1
            Password Reset

          %p
            Please enter your email address. We will send you instructions on how
            to reset your password.

          = form_for :password, url: passwords_path do |form|
            .form-group
              = form.label :email
              = form.email_field :email, class: 'form-control',
                placeholder: 'Email address'

            = form.submit 'Request instructions', class: 'btn btn-primary'
      """
    And the file "app/views/sessions/new.html.haml" should contain exactly:
      """
      .row
        .col-md-4.col-md-offset-4

          %h1
            Please sign in

          = form_for :session, url: session_path do |form|
            .form-group
              = form.label :email
              = form.email_field :email, class: 'form-control',
                placeholder: 'Email Address', required: true, autofocus: true

            .form-group
              = form.label :password
              = form.password_field :password, class: 'form-control', required: true,
                placeholder: 'Password'

            %p
              = form.submit 'Sign in', class: 'btn btn-primary'
              = link_to 'Forgot password', new_password_path, class: 'btn btn-link'

      """
    And the file "config/environments/test.rb" should contain:
      """
        # Enable quick-signin in tests: `visit homepage(as: User.last!)`
        config.middleware.use Clearance::BackDoor

      """
    And the file "config/initializers/clearance.rb" should contain "  config.mailer_sender = 'system@example.com'"
    And a file named "config/locales/clearance.en.yml" should exist
    And the file "config/routes.rb" should contain:
      """
        resources :users do
          resource :password, controller: 'passwords',
            only: %i[edit update]
        end

        # Clearance
        get '/login', to: 'clearance/sessions#new', as: 'sign_in'
        resource :session, controller: 'clearance/sessions', only: [:create]
        resources :passwords, controller: 'passwords', only: [:create, :new]
        delete '/logout', to: 'clearance/sessions#destroy', as: 'sign_out'
      """
    And there should be a migration with:
      """
      class AddClearanceToUsers < ActiveRecord::Migration[5.1]
        def self.up
          change_table :users do |t|
            t.string :encrypted_password, limit: 128
            t.string :confirmation_token, limit: 128
            t.string :remember_token, limit: 128
          end

          add_index :users, :email
          add_index :users, :remember_token

          users = select_all("SELECT id FROM users WHERE remember_token IS NULL")

          users.each do |user|
            update <<-SQL
              UPDATE users
              SET remember_token = '#{Clearance::Token.new}'
              WHERE id = '#{user['id']}'
            SQL
          end
        end

        def self.down
          change_table :users do |t|
            t.remove :encrypted_password, :confirmation_token, :remember_token
          end
        end
      end
      """
    And the file "features/authentication.feature" should contain exactly:
      """
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
            \"\"\"
            From: system@example.com
            To: henry@example.com
            Subject: Change your password

            To reset your password, please follow this link:
            \"\"\"

          When I follow the first link in the email
          Then I should be on the new password page for the user above
            And I should see "Reset Password"

          When I fill in "Choose password" with "new-password"
            And I press "Update password"
          Then I should see "Password successfully changed" within the flash
            And I should be on the homepage
      """
    And the file "features/users.feature" should contain:
      """


        Background:
          Given there is a user
            And I sign in as the user above

      """
    And the file "features/step_definitions/authentication_steps.rb" should contain exactly:
      """
      When /^I (?:am signed|sign) in as the user above$/ do
        user = User.last!
        visit root_path(as: user) # Using Clearance::BackDoor
      end
      """
    And the file "features/support/paths.rb" should contain:
      """

          # Authentication
          when 'the sign-in form'
            sign_in_path
          when 'the reset password page'
            new_password_path
          when 'the new password page for the user above'
            edit_user_password_path(User.last!)

      """
    And the file "spec/factories/factories.rb" should contain:
      """
        factory :user do
          sequence(:email) { |i| "user-#{ i }@example.com" }
          password 'password'
        end
      """

    When I run cucumber
    Then the features should pass
