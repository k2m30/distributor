require 'bundler/capistrano'

server '144.76.161.235', :web, :app, :db, primary: true
#server '78.47.161.129', :web, :app, :db, primary: true #production

set :whenever_command, 'bundle exec whenever'
require 'whenever/capistrano'
set :application, 'distributor'
set :user, 'deployer'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository, 'https://github.com/k2m30/distributor'
set :branch, 'master'
set :host, '144.76.161.235'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
default_run_options[:shell] = '/bin/bash --login'

after 'deploy', 'deploy:cleanup' # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
      run "RAILS_ENV=production #{current_path}/bin/delayed_job #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read('config/database.example.yml'), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after 'deploy:setup', 'deploy:setup_config'

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after 'deploy:finalize_update', 'deploy:symlink_config'

  desc 'Make sure local git is in sync with remote.'
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts 'WARNING: HEAD is not the same as distributor/master'
      puts 'Run `git push` to sync changes.'
      exit
    end
  end
  before 'deploy', 'deploy:check_revision'

  #namespace :assets do
  #  desc 'Run the precompile task locally and rsync with shared'
  #  task :precompile, :roles => :web, :except => { :no_release => true } do
  #    from = source.next_revision(current_revision)
  #    if releases.length <= 1 || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
  #      %x{bundle exec rake assets:precompile}
  #      %x{rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/assets #{user}@#{host}:#{shared_path}}
  #      %x{bundle exec rake assets:clean}
  #    else
  #      logger.info 'Skipping asset pre-compilation because there were no asset changes'
  #    end
  #  end
  #end
end