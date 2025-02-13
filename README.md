# 🎟️ Sistema de Venda de Rifas Online

## 📌 Sobre o Projeto
Este projeto é um sistema de venda de rifas online desenvolvido em **Ruby on Rails**.
Ele permite a criação, gerenciamento e venda de rifas de forma digital.
A forma de pagamento integrado é o checkout de pix do mercado pago. 

Através desse sistema é possível vender números que serão sorteados aleatoriamente por algoritmo implantado nas regras de negócios e atribuídos ao cliente, sendo que obrigatoriamente o cliente deverá estar cadastrado na base de dados do sistema, em resumo o fluxo seria selecionar a campanha na qual o cliente quer participar, escolher a quantidade de números e efetuar o pagamento pix para receber a quantidade de números escolhidos, além desse fluxo principal existem vários outros importantes como por exemplo visualização de números obtidos pelo cliente.

Este sistema também tem a parte administrativa onde é possível visualizar pagamentos, clientes cadastrados, iniciar campanhas, números vendidos e etc.

## 🚀 Tecnologias Utilizadas
- **Ruby**: 2.4.4
- **Rails**: 5.2.0
- **Banco de Dados**: PostgreSQL
- **Gerenciador de Dependências**: Bundler

## 📷 Screenshots

![Início CRM](https://github.com/user-attachments/assets/65d92304-8132-467b-b75b-19f3ddabccd7)

![image](https://github.com/user-attachments/assets/d0078d25-6043-4446-8139-0f24bf0ea9bc) 

![image](https://github.com/user-attachments/assets/29d20dcf-06d2-4468-b959-73eca5e3e83c) 

![image](https://github.com/user-attachments/assets/f750bd3a-997b-4f77-a7b7-da8abdb63e50)




## 🛠️ Como Configurar o Projeto
### 📥 Clonar o Repositório
```bash
git clone https://github.com/Khaldewey/cash-premium
cd cash-premium
```

### 📦 Instalar Dependências
```bash
bundle install
```

### ⚙️ Configurar o Banco de Dados
```bash
rails db:create db:migrate
```

### 🚀 Iniciar o Servidor
```bash
rails server
```
Acesse o sistema em: `http://localhost:3000`

## 🔧 Configuração do Banco de Dados
O sistema utiliza **PostgreSQL**. Certifique-se de configurar corretamente o `database.yml`.
Exemplo de configuração:

```yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

production:
  <<: *default
  database: rifa_production
  username: seu_usuario
  password: sua_senha
  host: localhost
```

## 📜 Licença
Este projeto está sob a licença MIT. Sinta-se livre para modificá-lo e usá-lo como preferir.

## 📬 Contato
Caso tenha dúvidas ou sugestões, entre em contato:
- **Email**: israel_alves77@hotmail.com
- **Linkedin**: www.linkedin.com/in/is-rael

---


