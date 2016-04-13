set :stage, :production

set :deploy_to, '/var/www/<%= app_name %>'
set :rails_env, 'production'
set :branch, 'production'

# server 'one.example.com', user: 'deploy-user', roles: %w(app web cron db)
# server 'two.example.com', user: 'deploy-user', roles: %w(app web)
