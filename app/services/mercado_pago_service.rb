# app/services/mercado_pago_service.rb
require 'mercadopago'

class MercadoPagoService
  def initialize(access_token)
    @mp = Mercadopago::SDK.new(access_token)
  end

  def create_pix_payment(amount, payer_email)
    payment_data = {
      transaction_amount: amount,
      description: 'Descrição do pagamento',
      payment_method_id: 'pix',
      payer: {
        email: payer_email
      }
    }

    result = @mp.payment.create(payment_data)
    payment = result[:response]

    payment # retorna o objeto de pagamento gerado
  end
end
