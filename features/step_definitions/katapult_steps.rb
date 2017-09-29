# Note: Aruba adds the project's bin/ directory to the path

When /^I install katapult$/ do
  append_to_file 'Gemfile', "gem 'katapult', path: '../../..'"
  run_simple 'rails generate katapult:install'
end

# This step is required for any feature because it generates config/database.yml
When /^I generate katapult basics$/ do
  with_aruba_timeout 60 do
    run_simple 'rails generate katapult:basics --db-user katapult --db-password secret'
  end
end

When /^I( successfully)? transform the application model$/ do |require_success|
  with_aruba_timeout 45 do
    # The second argument of #run_simple defaults to `true`
    run_simple 'rails generate katapult:transform lib/katapult/application_model.rb', !!require_success
  end
end

Then 'Capistrano should be configured' do
  step 'the file "Capfile" should contain:', <<-CONTENT
# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
require 'capistrano/bundler'
require 'capistrano/maintenance'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'whenever/capistrano'

Dir.glob('lib/capistrano/tasks/*.rake').each do |r|
  # `import r` calls Rake.application.add_import(r), which imports the file only
  # *after* this file has been processed, so the imported tasks would not be
  # available to the hooks below.
  Rake.load_rakefile r
end

before 'deploy:updating', 'db:dump'
after 'deploy:published', 'deploy:restart'
after 'deploy:published', 'db:warn_if_pending_migrations'
after 'deploy:published', 'db:show_dump_usage'
after 'deploy:finished', 'deploy:cleanup' # https://makandracards.com/makandra/1432
  CONTENT

  step 'the file "config/deploy.rb" should contain:', <<-CONTENT
# Default value for :format is :pretty
# set :format, :pretty

set :log_level, :info # %i(debug info error), default: :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, %w(config/database.yml config/secrets.yml)

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, %w(log public/system tmp/pids)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :application, 'katapult_test_app'
set :keep_releases, 10
set :ssh_options, {
  forward_agent: true
}
set :scm, :git
set :repo_url, 'git@code.makandra.de:makandra/katapult_test_app.git'

# set :whenever_roles, :cron
# set :whenever_environment, defer { stage }
# set :whenever_command, 'bundle exec whenever'

set :maintenance_template_path, 'public/maintenance.html.erb'
CONTENT

  step 'the file "config/deploy/staging.rb" should contain:', <<-CONTENT
set :stage, :staging

set :deploy_to, '/var/www/katapult_test_app-staging'
set :rails_env, 'staging'
set :branch, ENV['DEPLOY_BRANCH'] || 'master'

# server 'example.com', user: 'deploy-user', roles: %w(app web cron db)
CONTENT

  step 'the file "config/deploy/production.rb" should contain exactly:', <<-CONTENT
set :stage, :production

set :deploy_to, '/var/www/katapult_test_app'
set :rails_env, 'production'
set :branch, 'production'

# server 'one.example.com', user: 'deploy-user', roles: %w(app web cron db)
# server 'two.example.com', user: 'deploy-user', roles: %w(app web)
CONTENT

  step 'the file "lib/capistrano/tasks/db.rake" should contain ":warn_if_pending_migrations"'
  step 'the file "lib/capistrano/tasks/deploy.rake" should contain "Show deployed revision"'
  step 'the file "lib/capistrano/tasks/passenger.rake" should contain "Restart Application"'

end

Then 'turbolinks should be removed' do
  step 'the file "app/views/layouts/application.html.erb" should not contain "turbolinks"'
  step 'the file "app/views/layouts/application.html.erb" should contain:', <<-CONTENT
    <%= stylesheet_link_tag    'application', media: 'all' %>
    <%= javascript_include_tag 'application' %>
  CONTENT
end

Then 'the asset pipeline should be removed' do
  step 'the directory "app/assets" should not exist'

  step 'the file "Gemfile" should not contain "sass-rails"'
  step 'the file "Gemfile" should not contain "therubyracer"'
end

Then 'webpacker should be employed' do
  step 'the file "app/webpack/packs/application.js" should contain "window.$ = jQuery"'
  step %(the file "app/webpack/assets/index.js" should contain "import './stylesheets/theme'")

  step 'the file "config/webpacker.yml" should contain "source_path: app/webpack"'
  step 'the file "config/webpack/environment.js" should contain:', <<-CONTENT
environment.plugins.set('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
  CONTENT

  step 'the file "features/support/webpacker.rb" should contain "def compile_once"'
  step 'the file "package.json" should contain "jquery"'
  step 'the file "package.json" should contain "bootstrap-sass"'

  step 'the file ".gitignore" should contain "node_modules"'
end
