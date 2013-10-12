namespace :deploy do

  task :updating do
    within :deploy_path do
      execute :git, :br
    end
  end

end