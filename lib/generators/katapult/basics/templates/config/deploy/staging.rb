set :stage, :staging

set :deploy_to, '/var/www/<%= app_name %>-staging'
set :rails_env, 'staging'
set :branch, ENV['DEPLOY_BRANCH'] || 'master'

# server 'example.com', user: 'deploy-user', roles: %w[app web cron db]
