namespace :git do
  desc 'Deploy via git pull'
  task :pull do
    on roles :app do
      within release_path do
        files_to_restore = %w(Gemfile.lock)
        on roles :db do
          files_to_restore.push('db/schema.rb')
        end
        execute :git, :checkout, '--', *files_to_restore
        execute :git, :fetch
        execute :git, :checkout, (fetch(:branch) || fetch(:stage))
        execute :git, :pull
      end
    end
  end

  desc 'Deploy via git reset --hard'
  task :reset_hard do
    on roles :app do
      within release_path do
        execute :git, :reset, "--hard origin/#{fetch(:branch) || fetch(:stage)}"
        execute :git, :pull
      end
    end
  end

  desc 'Show hash of what is deployed, min chars to uniquely identify'
  task :'rev-parse' do
    on roles :app do
      within release_path do
        execute :git, :'rev-parse', '--short=0', 'HEAD'
      end
    end
  end

  desc 'Show what commit is currently deployed'
  task :deployed do
    on roles :app do
      within release_path do
        execute :git, :log, "--color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cd) %C(bold blue)<%an>%Creset' --abbrev --date=iso -1"
      end
    end
  end

  desc 'Determine the unix timestamp that the revision that will be deployed was created'
  task :set_current_revision_time do
    on roles :app do
      within release_path do
        execute :git, "--no-pager log -1 --pretty=format:\"%ct\" #{fetch(:branch)}"
      end
    end
  end
end
