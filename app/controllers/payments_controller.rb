class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create_pix_payment]
  
  def create_pix_payment
    require 'httparty'
    require 'json' 
    require 'securerandom'
    
    # Dados do pagamento
    payment_data = {
      transaction_amount: 20,
      description: "Bilhete Cash Prêmio",
      payment_method_id: "pix",
      payer: {
        email: "teste@teste.com",
        first_name: "Test",
        last_name: "User",
        identification: {
          type: "CPF",
          number: "19119119100"
        },
        address: {
          zip_code: "06233200",
          street_name: "Av. das Nações Unidas",
          street_number: "3003",
          neighborhood: "Bonfim",
          city: "Osasco",
          federal_unit: "SP"
        }
      }
    }
    
    # Gerar um valor único para a chave de idempotência
    idempotency_key = SecureRandom.uuid
    
    # URL da API do Mercado Pago para criar um pagamento
    url = 'https://api.mercadopago.com/v1/payments'
    
    # Headers da requisição
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer TEST-191553553627645-052119-e02f16e5c678bc716b9d93cfcdba8d03-472243321",
      'X-Idempotency-Key' => idempotency_key
    }
    
    # Realizar a requisição POST para criar o pagamento
    response = HTTParty.post(url, headers: headers, body: payment_data.to_json)
    puts payment_data.to_json
    
    # Verificar a resposta
    if response.code == 201
      payment = JSON.parse(response.body)
      # puts "Pagamento criado com sucesso:"
      # puts payment
    else
      puts "Erro ao criar o pagamento:"
      puts "Status: #{response.code}"
      puts "Body: #{response.body}"
    end 

    render json: response.body, status: response.code
  end
  

    
  end
  