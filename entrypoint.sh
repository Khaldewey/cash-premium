#!/bin/sh
set -e

# Pré-compilar assets
RAILS_ENV=production bundle exec rake assets:precompile

# Executar migrações e seeds
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake db:seed RAILS_ENV=production

# Iniciar o servidor Rails
exec rails server -b 0.0.0.0 -p 3000
