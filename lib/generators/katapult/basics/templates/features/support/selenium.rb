chrome_args = %w[--mute-audio --disable-infobars]
no_password_bubble = {
  'credentials_enable_service' => false,
  'profile.password_manager_enabled' => false
}

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    args: chrome_args,
    prefs: no_password_bubble
  )
end
