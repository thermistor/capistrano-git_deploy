namespace :deploy do
  task :starting do
    invoke "deploy:print_config_variables" if fetch(:print_config_variables, false)
    invoke "deploy:check"
    invoke "deploy:symlink:shared"
  end

  task :print_config_variables do
    puts
    puts "------- Printing current config variables -------"
    env.keys.each do |config_variable_key|
      if is_question?(config_variable_key)
        puts "#{config_variable_key.inspect} => Question (awaits user input on next fetch(#{config_variable_key.inspect}))"
      else
        puts "#{config_variable_key.inspect} => #{fetch(config_variable_key).inspect}"
      end
    end

    puts
    puts "------- Printing current config variables of SSHKit mechanism -------"
    puts env.backend.config.inspect
    # puts env.backend.config.backend.config.ssh_options.inspect
    # puts env.backend.config.command_map.defaults.inspect

    puts
  end

  task :updating do
    invoke 'git:reset_hard'
  end

  task :publishing do
    invoke 'deploy:restart'
  end

  desc "Check required files and directories exist"
  task :check do
    invoke "deploy:check:directories"
    invoke "deploy:check:linked_dirs"
    invoke "deploy:check:make_linked_dirs"
    invoke "deploy:check:linked_files"
  end

  namespace :check do
    desc "Check shared directory exists"
    task :directories do
      on release_roles :all do
        execute :mkdir, "-p", shared_path
      end
    end

    desc "Check directories to be linked exist in shared"
    task :linked_dirs do
      next unless any? :linked_dirs
      on release_roles :all do
        execute :mkdir, "-p", linked_dirs(shared_path)
      end
    end

    desc "Check directories of files to be linked exist in shared"
    task :make_linked_dirs do
      next unless any? :linked_files
      on release_roles :all do |_host|
        execute :mkdir, "-p", linked_file_dirs(shared_path)
      end
    end

    desc "Check files to be linked exist in shared"
    task :linked_files do
      next unless any? :linked_files
      on release_roles :all do |host|
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

    desc "Symlink files and directories from shared to release"
    task :shared do
      invoke "deploy:symlink:linked_files"
      invoke "deploy:symlink:linked_dirs"
    end

    desc "Symlink linked directories"
    task :linked_dirs do
      next unless any? :linked_dirs
      on release_roles :all do
        execute :mkdir, "-p", linked_dir_parents(release_path)

        fetch(:linked_dirs).each do |dir|
          target = release_path.join(dir)
          source = shared_path.join(dir)
          next if test "[ -L #{target} ]"
          execute :rm, "-rf", target if test "[ -d #{target} ]"
          execute :ln, "-s", source, target
        end
      end
    end

    desc "Symlink linked files"
    task :linked_files do
      next unless any? :linked_files
      on release_roles :all do
        execute :mkdir, "-p", linked_file_dirs(release_path)

        fetch(:linked_files).each do |file|
          target = release_path.join(file)
          source = shared_path.join(file)
          next if test "[ -L #{target} ]"
          execute :rm, target if test "[ -f #{target} ]"
          execute :ln, "-s", source, target
        end
      end
    end
  end

  task :new_release_path do
    # noop
  end

  desc "Place a REVISION file with the current revision SHA in the current release path"
  task :set_current_revision  do
    on release_roles(:all) do
      within release_path do
        execute :echo, "\"#{fetch(:current_revision)}\" > REVISION"
      end
    end
  end

  task :set_previous_revision do
    on release_roles(:all) do
      target = release_path.join("REVISION")
      if test "[ -f #{target} ]"
        set(:previous_revision, capture(:cat, target, "2>/dev/null"))
      end
    end
  end

  task :restart
  task :failed
end
