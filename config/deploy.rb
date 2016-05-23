# Capistrano Configuration
lock '3.4.0'

############################################
# Our Project.
set :application, 'your-website'
set :repo_url, ''
set :scm, :git
############################################

# http://capistranorb.com/documentation/advanced-features/ptys/
set :pty, true

# Log Output
set :format , :pretty
# :debug :error :info
set :log_level, :info

# Composer
namespace :deploy do
  after :starting, 'composer:install_executable'
end

# Linking Dirs
set :linked_dirs, %w{uploads languages}

# Composer
namespace :deploy do
  after :starting, 'composer:install_executable'
end

# Linking Dirs
set :linked_dirs, %w{uploads languages}

# Change the path to /usr/bin/ssh
# on Mittwald-Servers the file is under /usr/local/bin/ssh located - symlink cannot be created
# @see #1472355
Rake::Task["deploy:check"].clear_actions
namespace :deploy do
    task check: :'git:wrapper'  do
        on release_roles :all do
            execute :mkdir, "-p", "#{fetch(:tmp_dir)}/#{fetch(:application)}/"
            upload! StringIO.new("#!/bin/sh -e\nexec /usr/local/bin/ssh -o PasswordAuthentication=no -o StrictHostKeyChecking=no \"$@\"\n"), "#{fetch(:tmp_dir)}/#{fetch(:application)}/git-ssh.sh"
            execute :chmod, "+x", "#{fetch(:tmp_dir)}/#{fetch(:application)}/git-ssh.sh"
        end
    end
end