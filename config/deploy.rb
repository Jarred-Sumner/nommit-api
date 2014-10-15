# config valid only for Capistrano 3.1
lock '3.1.0'


set :rvm_type, :user
set :rvm_ruby_version, '2.1.3'

set :application, 'nommit-api'
set :repo_url, 'git@github.com:Jarred-Sumner/nommit-api.git'

set :deploy_to, '/home/deploy/nommit-api'

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
