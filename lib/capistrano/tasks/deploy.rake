namespace :deploy do

  task :updating do
    on roles :app do
      within deploy_path do
        execute :git, :fetch
      end
    end
  end

  task :publishing do
    invoke 'deploy:restart'
  end

end