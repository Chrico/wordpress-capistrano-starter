set :stage, :staging

############################################
# Configure your envoirment here.
set :host, 'your-host.de'
set :user, 'your-user'
set :webdir,  '/your/path/to/web/dir'
############################################


# Server settings
server '#{fetch(:host)}', user: '#{fetch(:user)}', roles: %w{app db web}

# Directories
set :deploy_to, "#{fetch(:webdir)}/deployments"
set :tmp_dir, "#{fetch(:webdir)}/tmp"

# Composer Settings
set :composer_install_flags, '--no-interaction --optimize-autoloader'
set :composer_roles, :all
set :composer_working_dir, -> { fetch(:release_path) }
set :composer_dump_autoload_flags, '--optimize'
set :composer_download_url, "https://getcomposer.org/installer"
SSHKit.config.command_map[:composer] = "php #{fetch(:tmp_dir)}/composer.phar"
