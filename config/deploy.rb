require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'dedent'

set :domain, ''
set :repository, 'http://git.agenciaacerte.com/acerte/#{repository_name}.git'
set :user, 'system user plesk'
set :db_name, ''
set :db_username, ''
set :db_password, ''

set :deploy_to, '/var/www/vhosts/#{domain}/site'
set :branch, 'master'
set :term_mode, nil
set :rvm_path, '/usr/local/rvm/scripts/rvm'


set :shared_paths, ['config/database.yml', 'tmp', 'log', 'public/uploads', 'public/assets']

task :environment do
  invoke :'rvm:use[ruby-2.0.0-p247]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/assets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/assets"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  invoke :'setup:db:database_yml'
end

desc "Populate database.yml"
task :'setup:db:database_yml' => :environment do
  database_yml = <<-DATABASE.dedent
    production:
      adapter: mysql2
      encoding: utf8
      pool: 5
      database: #{db_name}
      username: #{db_username}
      password: #{db_password}
  DATABASE
  queue! %{
    echo "-----> Populating database.yml"
    echo "#{database_yml}" > #{deploy_to}/shared/config/database.yml
    echo "-----> Done"
  }
end

desc "Seed data to the database"
task :seed => :environment do
  queue "cd #{deploy_to}/current"
  queue "bundle exec rake db:seed RAILS_ENV=#{rails_env}"
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    queue "touch #{deploy_to}/shared/tmp/restart.txt"
  end
end
