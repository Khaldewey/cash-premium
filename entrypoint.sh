#!/bin/sh

# Espera o banco de dados estar pronto
until nc -z -v -w30 $DATABASE_HOST 5432
do
  echo "Waiting for database connection..."
  sleep 1
done

# Executa as migrações do banco de dados
bundle exec rake db:environment:set RAILS_ENV=test
bundle exec rake assets:precompile RAILS_ENV=test
bundle exec rake db:migrate
bundle exec rake db:environment:set RAILS_ENV=test

# Inicia o servidor Rails
exec "$@"