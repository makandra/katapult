namespace :passenger do
  desc 'Restart Application'
  task :restart do
    on roles :app do
      execute "sudo passenger-config restart-app --ignore-app-not-running #{ fetch(:deploy_to) }"
    end
  end
end
