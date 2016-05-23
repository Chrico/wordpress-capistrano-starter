# WordPress Capistrano Starter

## Table of Contents

* [Requirements](#requirements)
  * [Install Ruby](#install-ruby)
  * [Install Capistrano](#install-capistrano)
  * [Install Bundler](#install-bundler)
  * [Install Composer](#install-composer)
* [Configure Capistrano](#configure-capistrano)
  * [Basic configuration](#basic-configuration)
  * [Environment](#environment)
* [Local Development](#local-development)
* [Remote Server](#remote-server)
* [Directory structure](#directory-structure)
* [wp-config.php](#wp-configphp)
* [Commands](#commands)
  * [View all available commands](#view-all-available-commands)
  * [Check if everything is fine](#check-if-everything-is-fine)
  * [Deployment and Rollback](#deployment-and-rollback)
  

## Requirements

* Ruby >= 2.0
* Capistrano 3.4.0
* Bundler 
* Composer
* Access via SSH Key to Server


### Install Ruby
* https://www.ruby-lang.org/de/downloads/
* https://www.ruby-lang.org/de/documentation/installation/
 
```
$ ruby -v
ruby 2.2.3p173 (2015-08-18 revision 51636) [x64-mingw32]
```

### Install Capistrano
[Capistrano](http://capistranorb.com/documentation/overview/what-is-capistrano/) is a remote server automation tool. It supports the scripting and execution of arbitrary tasks, and includes a set of sane-default deployment workflows. 

Howto install: http://capistranorb.com/documentation/getting-started/installation/

```
$ gem install capistrano
$ cap -v
Capistrano Version: 3.4.0 (Rake Version: 10.5.0)
```

### Install Bundler
[Bundler](https://github.com/capistrano/bundler/) is a package manager for Capistrano v3.

```
$ gem install bundler
$ bundler -v
Bundler version 1.11.2
```

### Install Composer
[Composer](https://getcomposer.org/) is a Dependency Manager for PHP.

* Howto install https://getcomposer.org/download/


## Configure Capistrano

### Basic configuration
Go to `config/deploy.rb` and configure your `application`-name and `repo_url`.

### Environment
To configure your environment, go to `config/deploy/staging.rb`. The file name equals to your deploy command `cap {environment} deploy` e.G. `cap staging deploy`).
 
Set your `host`, `user` and `webdir` which is the relative path to your web project on remote server.

## Local development

This Starterkit only represents your `wp-content`-directory and does not restrict your local workflow. You can..
 
* Replace your `wp-content` locally. 
* Create a symlink to this folder in your WordPress-installation.
* Load WordPress via Composer
* ...

To work with Plugins and Themes, just add them to your `composer.json` and run `composer install`.

## Remote Server

### Directory structure

```
| /cache
| /deployments
|_ current/ ~> ~/deployments/releases/YYYYMMDDHHIISS/
|__ releases/
|___ <release folders with YYYYMMDDHHIISS>
|__ repo/
|___ <VCS data>
|__ shared/
|___ <linked_files & linked_dirs>
|_ revisions.log
| /tmp
|___ composer.phar
| /www
|___ <WordPress installation>
|___|___ wp-content/ ~> ~/../deployments/current/
| wp-config.php
```

### wp-config.php

To load the correct `wp-content/`-folder into your WordPress-installation, you've to add following line to your `wp-config.php`: 

```php
define( 'WP_CONTENT_DIR', realpath( __DIR__ . '/deployments/current' ) );
```

## Commands

### View all available commands

```ruby
$ cap -T
```

### Check if everything is fine

```ruby
cap {environment} deploy:check
```

What happens:

1. Test SSH-connection.
2. Check Git-connection.
3. Create folders withing `deployments/`.

### Deployment and Rollback

```ruby
$ cap {environment} deploy
```

What happens:

1. Read the HEAD of the selected branch.
2. Create `shared`-folder if not existing.
3. Update `~/deployments/repo` via `git checkout`.
4. Execute `composer update`. 
5. Create `release`-folder if not existing.
6. Create new folder - with date and time as name - in `release`.
7. Copy the current branch from `repo` into this folder.
8. Update all symlinks for `releases/{latest release}` and `shared/` to `current/`.
9. Cleanup old releases - by default the last 5 releases.

```ruby
$ cap {environment} deploy:rollback
```

What happens:

1. Change Symlink on `current/` in `release/{current release - 1}`.
