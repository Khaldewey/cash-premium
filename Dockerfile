# Use a imagem base do Ubuntu 18.04
FROM ubuntu:18.04

# Atualize os pacotes e instale as dependências do sistema necessárias para o Ruby, o Rails e o PostgreSQL
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    libreadline-dev \
    imagemagick \
    libmagickwand-dev \
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

# Defina o diretório de trabalho
WORKDIR /myapp

# Copie os arquivos do aplicativo para o contêiner
COPY . .

# Copie o entrypoint script e defina as permissões
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Instale as dependências do Ruby
RUN bundle install

# Exponha a porta 3000 para acessar o aplicativo Rails
EXPOSE 3000

# Configure o entrypoint e o comando padrão
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]