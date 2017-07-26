Then 'the ruby-version file should be up-to-date' do
  configured_ruby = File.read('.ruby-version').strip
  expect(configured_ruby).to eq Katapult::RUBY_VERSION
end

Then 'the configured Rails version should be listed in the Gemfile.lock' do
  rails_version = Katapult::RAILS_VERSION
  step %(the file "Gemfile.lock" should contain "    rails (#{rails_version})")
end

Then 'the output should contain the configured Rails version' do
  step %(the output should contain "Using rails #{Katapult::RAILS_VERSION}")
end
