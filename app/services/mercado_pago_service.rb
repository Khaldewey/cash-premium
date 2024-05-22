# app/services/mercado_pago_service.rb
class MercadoPagoService
    def initialize(access_token)
      @mp = MercadoPago.new(access_token)
    end
  
    def create_pix_preference(member, lottery, amount)
      preference_data = {
        items: [
          {
            title: "Compra de Números para Sorteio",
            quantity: 1,
            currency_id: "BRL",
            unit_price: amount
          }
        ],
        payer: {
          email: member.email
        },
        external_reference: member.id.to_s,
        payment_methods: {
          excluded_payment_types: [
            { id: "credit_card" },
            { id: "debit_card" }
          ]
        },
        transaction_amount: amount,
        description: "Compra de Números para Sorteio",
        payment_method_id: "pix"
      }
  
      preference = @mp.create_preference(preference_data)
      preference["response"]
    end
  end
  