default_environment["PATH"]= "/h/ruby/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/dltservice/bin:/h/oracle/instantclient"
default_enviroment["LD_LIBRARY_PATH"]= "/h/oracle/instantclient"
set :stages, %w(staging rfp production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
 require "bundler/capistrano"

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :application, "bblearn"
set :deploy_to, "/h/dlt/opt/RailsApps/#{application}"
set :user, "dltservice"
set :use_sudo,false
set :ssh_options, {:forward_agent=>true}
# TODO <sjungling> add config/production.rb and move rails_config_files to env. specific deploy files
set :rails_config_files, %w(config.yml database.yml)

# =============================================================================
# REVISION CONTROL
# =============================================================================
set :scm, :git
set :repository,  "apphostdev:/h/dlt/git/#{application}.git"
set :deploy_via, :remote_cache

# =============================================================================
# CUSTOM HOOKS / CAP METHODS
# =============================================================================
after "deploy:update_code" do
  rails_config_files.each do |filename|
    run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
  end
end

before "deploy" do
  run "echo 'XXXXXXXXXXXXXXXXXXXXXX'"
  run "echo $PATH"
  run "echo 'XXXXXXXXXXXXXXXXXXXXXX'"
  deploy:cleanup
end

namespace :deploy do
  desc "Touch restart.txt to reload the application"
  task :restart do
    run "touch #{release_path}/tmp/restart.txt" 
  end
end
