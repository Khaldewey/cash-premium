class Member::PaymentService
    require 'httparty'
    require 'json'
    require 'securerandom'
  
    def self.create_pix_payment(member, amount)
      # Dados do pagamento
      payment_data = {
        transaction_amount: amount,
        description: "Bilhete Cash Prêmio",
        payment_method_id: "pix",
        payer: {
          email: member.email,
          first_name: member.name,
          last_name: nil,
          identification: {
            type: "CPF",
            number: nil
          },
          address: {
            zip_code: nil,
            street_name: nil,
            street_number: nil,
            neighborhood: nil,
            city: nil,
            federal_unit: nil
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
      
      # Retornar a resposta da API
      response
    end
  end
  