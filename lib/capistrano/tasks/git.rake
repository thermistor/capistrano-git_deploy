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

end
