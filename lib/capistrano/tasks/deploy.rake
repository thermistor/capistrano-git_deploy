namespace :deploy do

  # framework hooks

  task :starting do
    invoke 'deploy:check'
    invoke 'deploy:symlink:shared'
  end

  task :updating do
    on roles :app do
      within release_path do
        execute :git, :checkout, 'db/schema.rb'
        execute :git, :pull
      end
    end
  end

  task :publishing do
    invoke 'deploy:restart'
  end

  # supporting tasks

  desc 'Check required files and directories exist'
  task :check do
    invoke "#{scm}:check"
    invoke 'deploy:check:directories'
    invoke 'deploy:check:linked_dirs'
    invoke 'deploy:check:make_linked_dirs'
    invoke 'deploy:check:linked_files'
  end

  namespace :check do
    desc 'Check shared directory exists'
    task :directories do
      on roles :all do
        execute :mkdir, '-pv', shared_path
      end
    end

    desc 'Check directories to be linked exist in shared'
    task :linked_dirs do
      next unless any? :linked_dirs
      on roles :app do
        execute :mkdir, '-pv', linked_dirs(shared_path)
      end
    end

    desc 'Check directories of files to be linked exist in shared'
    task :make_linked_dirs do
      next unless any? :linked_files
      on roles :app do |host|
        execute :mkdir, '-pv', linked_file_dirs(shared_path)
      end
    end

    desc 'Check files to be linked exist in shared'
    task :linked_files do
      next unless any? :linked_files
      on roles :app do |host|
        linked_files(shared_path).each do |file|
          unless test "[ -f #{file} ]"
            error t(:linked_file_does_not_exist, file: file, host: host)
            exit 1
          end
        end
      end
    end
  end

  namespace :symlink do

    desc 'Symlink files and directories from shared to release'
    task :shared do
      invoke 'deploy:symlink:linked_files'
      invoke 'deploy:symlink:linked_dirs'
    end

    desc 'Symlink linked directories'
    task :linked_dirs do
      next unless any? :linked_dirs
      on roles :app do
        execute :mkdir, '-pv', linked_dir_parents(release_path)

        fetch(:linked_dirs).each do |dir|
          target = release_path.join(dir)
          source = shared_path.join(dir)
          unless test "[ -L #{target} ]"
            if test "[ -d #{target} ]"
              execute :rm, '-rf', target
            end
            execute :ln, '-s', source, target
          end
        end
      end
    end

    desc 'Symlink linked files'
    task :linked_files do
      next unless any? :linked_files
      on roles :app do
        execute :mkdir, '-pv', linked_file_dirs(release_path)

        fetch(:linked_files).each do |file|
          target = release_path.join(file)
          source = shared_path.join(file)
          unless test "[ -L #{target} ]"
            if test "[ -f #{target} ]"
              execute :rm, target
            end
            execute :ln, '-s', source, target
          end
        end
      end
    end

  end

end