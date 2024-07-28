class Admin::TransactionsController < Admin::ResourceController 
  def index
    @collection  = Transaction.order(created_at: :desc).paginate(page: params[:page], per_page: 8)

    Parallel.each(@collection, in_threads: 5) do |transaction|
      response = JSON.parse(check_transaction(transaction.transaction_id).body)
  
      if transaction.status != response.dig("status")
        transaction.update_attribute(:status, response.dig("status"))
      end

      if transaction.expiration_time.present? && transaction.expiration_time < Time.current && transaction.status == "pending"
        transaction.update(status: "cancelled")
      end
    end
  end

  def search
    @collection = Transaction.all

    if params[:search].present?
      if params[:search][:lottery_id].present?
        @collection = @collection.where(lottery_id: params[:search][:lottery_id])
      end
      if params[:search][:member_id].present?
        @collection = @collection.where(member_id: params[:search][:member_id])
      end
      if params[:search][:status].present?
        @collection = @collection.where(status: params[:search][:status])
      end
    end

    @collection = @collection.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
    render :index
  end

  def check_transaction(id)
    access_token = ENV.fetch("MERCADO_PAGO_ACCESS_TOKEN")
    transaction_id = id

    # URL da API do Mercado Pago para consultar um pagamento específico
    url = "https://api.mercadopago.com/v1/payments/#{transaction_id}"


    # Headers da requisição
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{access_token}"
    }

    # Realizar a requisição GET para consultar o pagamento
    response = HTTParty.get(url, headers: headers)  
  end 


end