namespace :git do

  desc 'Deploy via git pull'
  task :pull do
    on roles :app do
      within release_path do
        execute :git, :checkout, '--', 'db/schema.rb', 'Gemfile.lock'
        execute :git, :fetch
        execute :git, :checkout, (fetch(:branch) || fetch(:stage))
        execute :git, :pull
      end
    end
  end

  desc 'Show hash of what is deployed, colour is min chars to uniquely identify'
  task :'rev-parse' do
    on roles :app do
      within release_path do
        execute :git, :'rev-parse', 'HEAD', '|', "GREP_COLORS='ms=34;1'", 'grep', '$(git rev-parse --short=0 HEAD)'
      end
    end
  end

end
