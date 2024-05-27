class PaymentsController < ApplicationController
    def index 
        require 'mercadopago'
        sdk = Mercadopago::SDK.new('TEST-191553553627645-052119-e02f16e5c678bc716b9d93cfcdba8d03-472243321')
        
        custom_headers = {
         'x-idempotency-key': SecureRandom.uuid
        }
        
        custom_request_options = Mercadopago::RequestOptions.new(custom_headers: custom_headers)
        
        payment_request = {
          transaction_amount: 100,
          description: 'Título do produto',
          payment_method_id: 'pix',
          payer: {
            email: 'israel_alves77@hotmail.com',
            identification: {
              type: 'CPF',
              number: '19119119100',
            }
          }
        }
        
        payment_response = sdk.payment.create(payment_request, request_options: custom_request_options)
        @payment = payment_response[:response] 
        puts @payment    

    end
    def create_pix_payment
      mercado_pago_service = MercadoPagoService.new('TEST-191553553627645-052119-e02f16e5c678bc716b9d93cfcdba8d03-472243321')
     
  
      amount = params[:amount].to_f # valor do pagamento
      payer_email = params[:payer_email] # e-mail do pagador
  
      payment = mercado_pago_service.create_pix_payment(amount, payer_email)
        
      render json: { payment_id: payment['id'] } # Retorna o ID do pagamento gerado
    end
  end
  