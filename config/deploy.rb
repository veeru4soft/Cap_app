require 'capistrano/ext/multistage'
require "bundler/capistrano" # Execute "bundle install" after deploy, but only when really needed
require "rvm/capistrano" # RVM integration


set :application, "cap_app"
set :scm, :git
set :repository, "https://github.com/veeru4soft/Cap_app.git"
set :scm_passphrase, ""
set :rails_env, "production"





set :stages, ["production", "staging"]
set :default_stage, "staging"

set :deploy_to, "/home/nyros/trails/cap_app"
set :user, "nyros" 
set :password, "12345678"


set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
role :app,  "10.90.90.142"#"10.90.90.109"
role :web, "10.90.90.142"
role :db, "10.90.90.142", :primary => true
set :use_sudo, false
=begin
task :production do
	server "10.90.90.147", :app, :web, :db, :primary => true
	set :deploy_to, "/home/nyros/cap_app"
	set :user, "nyros" 
	set :password, "12345678"
end

task :staging do
	server "10.90.90.142", :app, :web, :db, :primary => true
	set :deploy_to, "/home/nyros/cap_app"
	set :user, "nyros" 
	set :password, "12345678"
end
=end

#set :rake,           "rake"
#  set :rails_env,      "production"
#  set :migrate_env,    ""
#  set :migrate_target, :latest
#set :deploy_via, :copy
#set :copy_dir, "/home/santosh/Desktop/tmp"
#set :remote_copy_dir, "/tmp"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :rvm_ruby_string, 'ruby-2.1.2' #Target ruby version
set :rvm_type, :user
#set :rvm_path, "/usr/local/rvm"
set :rvm_install_with_sudo, true

after "deploy", "deploy:bundle_gems"
after "deploy:bundle_gems", "deploy:start"


 namespace :deploy do
   task :bundle_gems do
   	 run "cd #{deploy_to}/current && bundle install"
   end
   task :start do 
   		on roles(:app) do
        within release_path do
          with rails_env: fetch(:rails_env) do
	set :app_port, ask("Port", nil)
	execute :bundle, "exec thin start -p #{fetch(:app_port)} -d -e RAILS_ENV=#{fetch(:rails_env)}"
        #execute :bundle, "exec rails s -p 2003 -d -e RAILS_ENV=#{fetch(:rails_env)}"
          end
        end
      end
   end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
   end


 end







#set :application, "set your application name here"
#set :repository,  "set your repository location here"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end