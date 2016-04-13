namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'passenger:restart'
  end

  desc 'Show deployed revision'
  task :revision do
    on roles :app do
      within current_path do
        info "Revision: #{ capture :cat, 'REVISION' }"
      end
    end
  end
end
