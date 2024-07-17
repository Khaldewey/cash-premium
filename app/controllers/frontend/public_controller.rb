class Frontend::PublicController < Frontend::ApplicationController

  def purchase
      @lottery = Lottery.find(params[:id])
      # @member = Member.find_by(phone: params[:phone]) 
  end  

  def events
      @lotteries = Lottery.where(status: true).paginate(page: params[:page], per_page: 5)
  end

  def check_phone
      @member = Member.find_by(phone: params[:phone])
      if @member
          render json: { found: true, name: @member.name, id: @member.id }
      else
          render json: { found: false }
      end
  end  

  def check_phone_numbers
    @member = Member.find_by(phone: params[:phone])
    if @member
        render json: { found: true, name: @member.name, id: @member.id }
    else
        render json: { found: false }
    end
  end 



  def contar_numeros(membros, id)
    total_numeros = 0
    membros.each do |membro|
      if membro[:tickets].empty?
        break
      else
        total_numeros += membro[:tickets][id.to_s].count
      end
    end
    
    return total_numeros
    
  end
    
  def new
    @lottery = Lottery.find(params[:id])
    @member = current_member 
  end

  def create
    @lottery = Lottery.find(params[:lottery_id])
    @member = Member.find(params[:member_id])
    
    @payment = Payment.new(
    lottery_id: params[:lottery_id],
    member_id: params[:member_id],
    transaction_id: params[:transaction_id],
    quantity: params[:quantity].to_i
    ) 

    @payment.save
    numbers_count = params[:quantity].to_i
    @all_numbers = []
    @all_numbers = verificar_numeros_participantes(Member.where("tickets @> ?", { @lottery.id.to_s => [] }.to_json), @lottery.id).flatten
    
    if @lottery.ticket - @all_numbers.count < numbers_count
      @failure = Failure.new(
      member_id: params[:member_id],
      payment_id: @payment.id
      )
      @failure.save 
      Rails.logger.error("Números: #{@lottery.ticket - @all_numbers.count}")
      redirect_to finished_numbers_path(transaction: @payment.transaction_id)
      return
    end
    if @member.tickets == nil || @member.tickets.empty?
      available_numbers = ((1..@lottery.ticket).to_a - @all_numbers)
      selected_numbers = available_numbers.sample(numbers_count)
      selected_numbers = []
      while selected_numbers.length < numbers_count do
        new_number = (1..@lottery.ticket).to_a.sample
        selected_numbers << new_number unless selected_numbers.include?(new_number) || @all_numbers.include?(new_number)
      end
      @member.lottery_id = @lottery.id
      @member.tickets ||= {} 
      @member.tickets[@lottery.id] ||= [] 
      @member.tickets[@lottery.id] += selected_numbers 
      # -raise
    else
      
      if @member.tickets.keys.include?(@lottery.id.to_s)
        # -raise
        available_numbers = ((1..@lottery.ticket).to_a - @all_numbers)
        selected_numbers = available_numbers.sample(numbers_count)
        # selected_numbers = (1..@lottery.ticket).to_a.sample(numbers_count)
        selected_numbers.each_with_index do |number, index|
          if @member.tickets[@lottery.id.to_s].include?(number)
            available_numbers = ((1..@lottery.ticket).to_a - @member.tickets[@lottery.id.to_s] - @all_numbers)
            new_number = available_numbers.sample(1).first
            selected_numbers[index] = new_number  # Substitui o número existente pelo novo número
          end
        end
        @member.tickets[@lottery.id.to_s].concat(selected_numbers)
        
      else
        available_numbers = ((1..@lottery.ticket).to_a - @all_numbers)
        selected_numbers = available_numbers.sample(numbers_count)
        while selected_numbers.length < numbers_count do
          new_number = (1..@lottery.ticket).to_a.sample
          selected_numbers << new_number unless selected_numbers.include?(new_number) || @all_numbers.include?(new_number)
        end
        @member.lottery_id = @lottery.id
        @member.tickets[@lottery.id] ||= [] 
        @member.tickets[@lottery.id] += selected_numbers
       
      end
    end
    
    
    # if selected_numbers.length == 0
    #   Rails.logger.error("Erro: Números selecionados estão vazios.")
    #   redirect_to error_path, alert: "Números esgotados sua compra será reembolsada."
    #   return
    # end
    if @member.save
      render json: {
        "numbers": selected_numbers,
        "timestamp": @payment.created_at
      }
      # redirect_to member_root_path, notice: "Números selecionados com sucesso!"
    else
      redirect_to error_path
      # render json: {
      #   "mensagem": "Números esgotados sua compra será reembolsada"
      # }
    end
   
    # else 
    #   redirect_to member_new_ticket_path, notice: "Números esgotados sua compra será reembolsada imediatamente pelo administrador !"
    # end
    
  end
    
  def verificar_numeros_participantes(membros, id)

    flag_array = []
    membros.each do |membro|
      unless membro.tickets[id.to_s].empty?
        flag_array << membro.tickets[id.to_s].flatten
      end
    end
    return flag_array
  end 

  def pix  
    @lottery = Lottery.find(params[:id])
    @member = Member.find_by(id: params[:yek])
    @numbers_count = params[:lottery][:quantity].to_i if params[:lottery][:quantity].present?
    # @payments = Payment.where(member_id: @member.id, lottery_id: @lottery.id)

    #Vou verificar se tem algum pagamento pendente aqui, se for encontrado vou renderizar o qrcode do pagamento pendente e colocar o cronometro do tempo que falta para pagar
    # Método para iniciar pagamento pix
    # payment_response = PaymentService.create_pix_payment(@member, params[:member][:quantity].to_i*@lottery.price)
    payment_response = create_pix_payment(@member, (params[:lottery][:quantity].to_f * @lottery.price.to_f).round(2))

    if payment_response.code == 201
      parsed_response = payment_response.parsed_response
      @qr_code_base64 = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code_base64")
      @qr_code = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code")
      @id = parsed_response.dig("id")
      
    else 
      logger.error "Payment response error: #{payment_response.inspect}"
      redirect_to error_path
    end
    
  end 

  def error
  end

  def finished
  end
  
  def pix_member 
    -raise 
    @lottery = Lottery.find(params[:id])
    @member = Member.find_by(id: params[:yek])
    @numbers_count =  params[:quantity] if params[:quantity].present?
    # @payments = Payment.where(member_id: @member.id, lottery_id: @lottery.id)

    #Vou verificar se tem algum pagamento pendente aqui, se for encontrado vou renderizar o qrcode do pagamento pendente e colocar o cronometro do tempo que falta para pagar
    # Método para iniciar pagamento pix
    # payment_response = PaymentService.create_pix_payment(@member, params[:member][:quantity].to_i*@lottery.price)
    
    payment_response = create_pix_payment(@member, (params[:quantity].to_i * @lottery.price.to_f).round(2))
    
    if payment_response.code == 201
      parsed_response = payment_response.parsed_response
      @qr_code_base64 = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code_base64")
      @qr_code = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code")
      @id = parsed_response.dig("id")
      
    else
      logger.error "Payment response error: #{payment_response.inspect}"
      render :purchase
    end
    
  end 

  def check_payment
    payment_id = params[:payment_id]
    
    # URL da API do Mercado Pago para consultar um pagamento específico
    url = "https://api.mercadopago.com/v1/payments/#{payment_id}"
    
    # Headers da requisição
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer APP_USR-7566194155648643-062420-1d483b50a9f63af77d98a4b0548d8006-576411779"
    }

    # Realizar a requisição GET para consultar o pagamento
    response = HTTParty.get(url, headers: headers)
    
    # Retornar a resposta da API
    render json: response.body
  end 


  def create_pix_payment(member, amount)
      
    # Calcula a data de expiração
    expiration_time = (Time.now + 10*60).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
    
    # precisa ser igual 2024-06-05T17:48:49.105-04:00
    
    # Dados do pagamento
    payment_data = {
      transaction_amount: amount,
      description: "Bilhete Cash Prêmio",
      payment_method_id: "pix",
      date_of_expiration: expiration_time,
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
    # TEST-191553553627645-052119-e02f16e5c678bc716b9d93cfcdba8d03-472243321 teste 
    # APP_USR-191553553627645-052119-4e39a47a786002999f0f2bd945244922-472243321 produção

    # TEST-7566194155648643-062420-491e0d66fe9706fad2c3f65286367516-576411779 teste Matheus
    # APP_USR-7566194155648643-062420-1d483b50a9f63af77d98a4b0548d8006-576411779 produção Matheus
    # Headers da requisição
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer APP_USR-7566194155648643-062420-1d483b50a9f63af77d98a4b0548d8006-576411779",
      'X-Idempotency-Key' => idempotency_key
    }

    # Realizar a requisição POST para criar o pagamento
    response = HTTParty.post(url, headers: headers, body: payment_data.to_json)
    
    # Retornar a resposta da API
    response
  end

  def term
  end 

  def numbers
    require 'date'
    @numbers =  params[:numbers].split(',')
    @member = Member.find(params[:yek])
  end 

  def search_numbers
    @member = Member.find(params[:yek])
  end 

  def comunications
    @comunications = Message.all
  end 

  def winners
    @winners = Lottery.where.not(winner: [nil, ""])
  end

  
  

  helper_method :contar_numeros
end