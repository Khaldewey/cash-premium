# Use a imagem base do Ubuntu 18.04
FROM ubuntu:18.04


# Atualize os pacotes e instale as dependências do sistema necessárias para o Ruby, o Rails e o PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libpq-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Instale uma versão específica do Ruby
RUN curl -fsSL https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.4.tar.gz | tar -xzC /tmp \
    && cd /tmp/ruby-2.4.4 \
    && ./configure \
    && make \
    && make install \
    && cd / \
    && rm -rf /tmp/ruby-2.4.4

# Verifique se o Ruby foi instalado corretamente
RUN ruby --version

# Instale o Bundler na versão desejada
RUN gem install bundler -v 2.3.5

COPY . .

# Copie os arquivos do aplicativo para o contêiner
COPY database.yml config/

# Define as variáveis de ambiente que vêm do Fly.io
ENV DATABASE_NAME=${DATABASE_NAME} \
    DATABASE_USER=${DATABASE_USER} \
    DATABASE_PASSWORD=${DATABASE_PASSWORD} \
    DATABASE_HOST=${DATABASE_HOST}

# Instale as dependências do Ruby
RUN bundle install

RUN bundle exec rake db:environment:set RAILS_ENV=production

# # Execute as tarefas de setup do banco de dados
# RUN DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:setup RAILS_ENV=production

RUN bundle exec rake assets:precompile RAILS_ENV=production

# Exponha a porta 3000 para acessar o aplicativo Rails
EXPOSE 3000

# Comando para iniciar o servidor Rails quando o contêiner for iniciado
CMD ["sh", "-c", "DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:migrate RAILS_ENV=production && bundle exec rake db:seed RAILS_ENV=production && rails server -b 0.0.0.0 -p 3000"]

# Configurando o script de entrada
# ENTRYPOINT ["./entrypoint.sh"]