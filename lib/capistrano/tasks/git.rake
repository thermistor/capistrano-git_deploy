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
      end
    end
  end

  desc 'Show hash of what is deployed, colour is min chars to uniquely identify'
  task :'rev-parse' do
    on roles :app do
      within release_path do
        execute :git, :'rev-parse', '--short=0', 'HEAD'
      end
    end
  end
end
