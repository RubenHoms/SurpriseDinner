# server-based syntax
# ======================
server 'surprisedinner.nl', roles: %w{web app db}

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/
# Feel free to add new variables to customise your setup.
set :user,              'surprisedinner'
set :stage,             :production
set :rails_env,         'production'
set :rack_env,          'production'
set :branch,            'master'
set :user,              'surprisedinner'
set :default_stage,     'production'
set :deploy_to,         "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :scm,               :git
set :linked_files,      fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :pty,               true
set :use_sudo,          true
set :linked_dirs,       fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/assets')
set :ssh_options,       forward_agent: true, user: fetch(:user), keys: ['~/.ssh/id_rsa.pub']
set :deploy_via,        :copy
set :keep_releases,     5
set :normalize_asset_timestamps, %(public/images public/javascripts public/stylesheets)
set :rvm_ruby_version, '2.2.5@surprisedinner'

# Puma settings
set :puma_rackup,             -> { File.join(current_path, 'config.ru') }
set :puma_state,              "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,                "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind,               "unix://#{shared_path}/tmp/sockets/puma.sock"    # accept array for multi-bind
set :puma_conf,               "#{shared_path}/puma.rb"
set :puma_access_log,         "#{shared_path}/log/puma_access.log"
set :puma_error_log,          "#{shared_path}/log/puma_error.log"
set :puma_role,               :app
set :puma_env,                'production'
set :puma_threads,            [2, 8]
set :puma_workers,            1
set :puma_worker_timeout,     nil
set :puma_init_active_record, true
set :puma_preload_app,        true
set :puma_prune_bundler,      true


namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc 'Make sure local git is in sync with remote.'
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts 'WARNING: HEAD is not the same as origin/master'
        puts 'Run `git push` to sync changes.'
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:smart_restart'
    end
  end

  before :starting,    :check_revision
  after :finishing,    :compile_assets
  after :finishing,    :cleanup
  after :finishing,    :restart
end