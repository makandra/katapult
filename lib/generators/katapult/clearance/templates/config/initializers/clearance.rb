Clearance.configure do |config|
  config.allow_sign_up = false
  # config.cookie_domain = '.example.com'
  # config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
  # config.cookie_name = 'remember_token'
  # config.cookie_path = '/'
  config.routes = false
  # config.httponly = true
  config.mailer_sender = 'system@example.com'
  # config.password_strategy = Clearance::PasswordStrategies::BCrypt
  # config.redirect_url = '/'
  # config.secure_cookie = true
  # config.sign_in_guards = []
  # config.user_model = User
end
