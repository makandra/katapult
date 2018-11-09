abort 'You must run this using "bundle exec ..."' unless ENV['BUNDLE_BIN_PATH'] || ENV['BUNDLE_GEMFILE']

# config valid only for current version of Capistrano
lock '<%= @version %>'

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
set :linked_dirs, %w(log public/system tmp/pids node_modules public/packs)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :application, '<%= app_name %>'
set :keep_releases, 10
set :ssh_options, {
  forward_agent: true
}
set :repo_url, 'git@code.makandra.de:makandra/<%= app_name %>.git'

# set :whenever_roles, :cron
# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :maintenance_template_path, 'public/maintenance.html.erb'
