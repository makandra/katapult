namespace :db do
  desc 'Warn about pending migrations'
  task :warn_if_pending_migrations do
    on primary :db do
      within current_path do
        with rails_env: fetch(:rails_env, 'production') do
          rake 'db:warn_if_pending_migrations'
        end
      end
    end
  end

  desc 'Do a dump of the DB on the remote machine using dumple'
  task :dump do
    on primary :db do
      within current_path do
        execute :dumple, '--fail-gently', fetch(:rails_env, 'production')
      end
    end
  end

  desc 'Show usage of ~/dumps/ on remote host'
  task :show_dump_usage do
    on primary :db do
      info capture :dumple, '-i'
    end
  end
end
