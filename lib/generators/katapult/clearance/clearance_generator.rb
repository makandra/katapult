# Generate authentication with Clearance

require 'katapult/generator'

module Katapult
  module Generators
    class ClearanceGenerator < Katapult::Generator

      MENU_BAR = 'app/views/layouts/_menu_bar.html.haml'

      desc 'Generate authentication with Clearance'
      check_class_collision
      source_root File.expand_path('../templates', __FILE__)


      def migrate
        rake 'db:migrate' # Clearance must see the users table in the db
      end

      def install_clearance
        insert_into_file 'Gemfile', <<-GEM, before: "gem 'katapult'"
gem 'clearance'

        GEM
        run 'bundle install --quiet'
        generate 'clearance:install'
      end

      def require_login
        file = 'app/controllers/application_controller.rb'
        insert_into_file file, <<-CONTENT, after: "Clearance::Controller\n"

  before_action :require_login
        CONTENT
      end

      def overwrite_clearance_controllers
        template 'app/controllers/passwords_controller.rb'
      end

      def create_clearance_views
        directory 'app/views/clearance_mailer'
        directory 'app/views/passwords'
        directory 'app/views/sessions'
      end

      def install_backdoor
        # This creepy indentation leads to correct formatting in the file
        application <<-CONTENT, env: 'test'
# Enable quick-signin in tests: `visit homepage(as: User.last!)`
  config.middleware.use Clearance::BackDoor
        CONTENT
      end

      def create_initializer
        template 'config/initializers/clearance.rb', force: true
      end

      def create_translations
        template 'config/locales/clearance.en.yml'
      end

      def create_routes
        route <<-ROUTES
resources :users do
    resource :password, controller: 'passwords',
      only: %i[edit update]
  end

  # Clearance
  get '/login', to: 'clearance/sessions#new', as: 'sign_in'
  resource :session, controller: 'clearance/sessions', only: [:create]
  resources :passwords, controller: 'passwords', only: [:create, :new]
  delete '/logout', to: 'clearance/sessions#destroy', as: 'sign_out'
        ROUTES
      end

      def add_current_user_to_layout
        template 'app/views/layouts/_current_user.html.haml'
        inject_into_file MENU_BAR, <<-CONTENT, after: /^\s+#navbar.*\n/
      = render 'layouts/current_user' if signed_in?
        CONTENT
      end

      def hide_navigation_unless_signed_in
        gsub_file MENU_BAR, /(render.*navigation')/, '\1 if signed_in?'
      end

      def add_sign_in_background_to_all_features
        Dir['features/*.feature'].each do |file|
          inject_into_file file, <<-CONTENT, after: /^Feature: .*$/


  Background:
    Given there is a user
      And I sign in as the user above
          CONTENT
        end
      end

      def create_authentication_feature
        template 'features/authentication.feature'
      end

      def create_authentication_steps
        template 'features/step_definitions/authentication_steps.rb'
      end

      def add_authentication_paths
        inject_into_file 'features/support/paths.rb', <<-CONTENT, after: 'case page_name'


    # Authentication
    when 'the sign-in form'
      sign_in_path
    when 'the reset password page'
      new_password_path
    when 'the new password page for the user above'
      edit_user_password_path(User.last!)

        CONTENT
      end

      def add_user_factory
        inject_into_file 'spec/factories/factories.rb', <<-'CONTENT', after: 'FactoryBot.define do'

  factory :user do
    sequence(:email) { |i| "user-#{ i }@example.com" }
    password 'password'
  end

        CONTENT
      end

    end
  end
end
