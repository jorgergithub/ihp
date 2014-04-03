set :application, 'iheartpsychics'

set :repo_url, 'git@github.com:gistia/iheartpsychics.git'

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/srv/ihp'
set :scm, :git

set :user, 'rails'

set :format, :pretty
set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

#set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 3

namespace :deploy do

  before :compile_assets, 'deploy:symlink:shared'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

namespace :shared_config do
  
  desc "Uploads local shared configs to remote servers"
  task :upload do
    on roles(:all) do
      upload! "config/database.yml", "#{fetch(:deploy_to)}/shared/config"
    end
  end
end