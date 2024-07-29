require 'parallel'
require 'active_support/time'

class Frontend::PublicController < Frontend::ApplicationController

  def purchase
      if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7].present?
        cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
      end
      @lottery = Lottery.find(params[:id])
      # @member = Member.find_by(phone: params[:phone]) 
  end  

  def events
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    end
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
  
  def capture_payment  
    @lottery = Lottery.find(params[:id])
    @member = Member.find_by(id: params[:yek])
    @numbers_count = params[:quantity].to_i if params[:quantity].present?
    @transaction_id = params[:transaction_id] = params[:transaction].to_i
  
    @transaction = Transaction.find_by(transaction_id: params[:transaction_id])
    
    # @payments = Payment.where(member_id: @member.id, lottery_id: @lottery.id)
    
    #Vou verificar se tem algum pagamento pendente aqui, se for encontrado vou renderizar o qrcode do pagamento pendente e colocar o cronometro do tempo que falta para pagar
    # Método para iniciar pagamento pix
    # payment_response = PaymentService.create_pix_payment(@member, params[:member][:quantity].to_i*@lottery.price)
  
      # Requisição ao Mercado Pago para obter os detalhes do pagamento
    payment_details = fetch_payment_details(@transaction.transaction_id)
    
    if payment_details
      @qr_code_base64 = payment_details.dig("point_of_interaction", "transaction_data", "qr_code_base64")
      @qr_code = payment_details.dig("point_of_interaction", "transaction_data", "qr_code")
      @id = payment_details["id"]
      date_of_expiration_string = payment_details["date_of_expiration"]
      # Converte a string para um objeto Time (ou DateTime)
      expiration_time = Time.iso8601(date_of_expiration_string)
      # Converte a hora para UTC
      expiration_time_utc = expiration_time.utc
      
      # Ajusta para o novo fuso horário (-03:00)
      # O novo fuso horário pode ser configurado diretamente com ActiveSupport::TimeZone
      timezone = ActiveSupport::TimeZone['Brasilia']  # Representa UTC-03:00
      
      # Converte o tempo UTC para o novo fuso horário
      @expiration_time = timezone.at(expiration_time_utc.to_i).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")      
    
    end 
  

    # Antigamento pagamento pix
    # payment_response = create_pix_payment(@member, (params[:lottery][:quantity].to_f * @lottery.price.to_f).round(2))

    # if payment_response.code == 201
    #   parsed_response = payment_response.parsed_response
    #   @qr_code_base64 = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code_base64")
    #   @qr_code = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code")
    #   @id = parsed_response.dig("id")
      
    # else 
    #   logger.error "Payment response error: #{payment_response.inspect}"
    #   redirect_to error_path
    # end
    
  end 

  def pix  
    @lottery = Lottery.find(params[:id])
    @member = Member.find_by(id: params[:yek])
    @numbers_count = params[:lottery][:quantity].to_i if params[:lottery][:quantity].present?
    # @payments = Payment.where(member_id: @member.id, lottery_id: @lottery.id)
    
    #Vou verificar se tem algum pagamento pendente aqui, se for encontrado vou renderizar o qrcode do pagamento pendente e colocar o cronometro do tempo que falta para pagar
    # Método para iniciar pagamento pix
    # payment_response = PaymentService.create_pix_payment(@member, params[:member][:quantity].to_i*@lottery.price)
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      # Requisição ao Mercado Pago para obter os detalhes do pagamento
      payment_details = fetch_payment_details(cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7])
      
      if payment_details
          @qr_code_base64 = payment_details.dig("point_of_interaction", "transaction_data", "qr_code_base64")
          @qr_code = payment_details.dig("point_of_interaction", "transaction_data", "qr_code")
          @id = payment_details["id"]

          date_of_expiration_string = payment_details["date_of_expiration"]
          # Converte a string para um objeto Time (ou DateTime)
          expiration_time = Time.iso8601(date_of_expiration_string)
          # Converte a hora para UTC
          expiration_time_utc = expiration_time.utc
          
          # Ajusta para o novo fuso horário (-03:00)
          # O novo fuso horário pode ser configurado diretamente com ActiveSupport::TimeZone
          timezone = ActiveSupport::TimeZone['Brasilia']  # Representa UTC-03:00
          
          # Converte o tempo UTC para o novo fuso horário
          @expiration_time = timezone.at(expiration_time_utc.to_i).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")      
    
      else
          cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
          create_and_store_payment
      end
    else     
        create_and_store_payment
    end
    # Antigamento pagamento pix
    # payment_response = create_pix_payment(@member, (params[:lottery][:quantity].to_f * @lottery.price.to_f).round(2))

    # if payment_response.code == 201
    #   parsed_response = payment_response.parsed_response
    #   @qr_code_base64 = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code_base64")
    #   @qr_code = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code")
    #   @id = parsed_response.dig("id")
      
    # else 
    #   logger.error "Payment response error: #{payment_response.inspect}"
    #   redirect_to error_path
    # end
    
  end 
  
  def fetch_payment_details(payment_id)
    # Exemplo de como fazer a requisição ao Mercado Pago
    # response = MercadoPago::Client.get("/v1/payments/#{payment_id}") 
    url = "https://api.mercadopago.com/v1/payments/#{payment_id}"
    
    access_token = ENV.fetch("MERCADO_PAGO_ACCESS_TOKEN")

    # Headers da requisição
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{access_token}"
    }

    # Realizar a requisição GET para consultar o pagamento
    response = HTTParty.get(url, headers: headers)
    if response.code == 200
        return response.parsed_response
    else
        logger.error "Erro ao buscar detalhes do pagamento: #{response.inspect}"
        return nil
    end
  end 

  def create_and_store_payment
    payment_response = create_pix_payment(@member, (@numbers_count * @lottery.price).round(2))
    if payment_response.code == 201
      parsed_response = payment_response.parsed_response
      payment_id = parsed_response.dig("id")
      if payment_id
        expires_at = 10.minutes.from_now
        cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7] = { value: payment_id, expires: 10.minutes.from_now, secure: Rails.env.production?, httponly: true }
        # cookies[:payment_expires_at] = { value: expires_at.to_i, expires: expires_at, secure: Rails.env.production?, httponly: true }
      end
      @qr_code_base64 = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code_base64")
      @qr_code = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code")
      @id = parsed_response.dig("id")
      @status = parsed_response.dig("status")

      date_of_expiration_string = payment_response["date_of_expiration"]
      # Converte a string para um objeto Time (ou DateTime)
      expiration_time = Time.iso8601(date_of_expiration_string)
      # Converte a hora para UTC
      expiration_time_utc = expiration_time.utc
      
      # Ajusta para o novo fuso horário (-03:00)
      # O novo fuso horário pode ser configurado diretamente com ActiveSupport::TimeZone
      timezone = ActiveSupport::TimeZone['Brasilia']  # Representa UTC-03:00
      
      # Converte o tempo UTC para o novo fuso horário
      @expiration_time = timezone.at(expiration_time_utc.to_i).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")      


      unless Transaction.find_by(transaction_id: @id)
        @transaction = Transaction.new(
          lottery_id:  @lottery.id,
          member_id: @member.id,
          transaction_id: @id,
          quantity: @numbers_count.to_i,
          status: @status,
          expiration_time: (Time.now + 10*60).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        )
        @transaction.save
      end

    else
      logger.error "Payment response error: #{payment_response.inspect}"
      redirect_to error_path
    end
  end

  def error
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    end
  end

  def finished
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    end
  end
  
  def pix_member 
    @lottery = Lottery.find(params[:id])
    @member = Member.find_by(id: params[:yek])
    @numbers_count =  params[:quantity] if params[:quantity].present?
    # @payments = Payment.where(member_id: @member.id, lottery_id: @lottery.id)

    #Vou verificar se tem algum pagamento pendente aqui, se for encontrado vou renderizar o qrcode do pagamento pendente e colocar o cronometro do tempo que falta para pagar
    # Método para iniciar pagamento pix
    # payment_response = PaymentService.create_pix_payment(@member, params[:member][:quantity].to_i*@lottery.price)
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      # Requisição ao Mercado Pago para obter os detalhes do pagamento
      payment_details = fetch_payment_details(cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7])

      if payment_details
          @qr_code_base64 = payment_details.dig("point_of_interaction", "transaction_data", "qr_code_base64")
          @qr_code = payment_details.dig("point_of_interaction", "transaction_data", "qr_code")
          @id = payment_details["id"]

          date_of_expiration_string = payment_details["date_of_expiration"]
          # Converte a string para um objeto Time (ou DateTime)
          expiration_time = Time.iso8601(date_of_expiration_string)
          # Converte a hora para UTC
          expiration_time_utc = expiration_time.utc
          
          # Ajusta para o novo fuso horário (-03:00)
          # O novo fuso horário pode ser configurado diretamente com ActiveSupport::TimeZone
          timezone = ActiveSupport::TimeZone['Brasilia']  # Representa UTC-03:00
          
          # Converte o tempo UTC para o novo fuso horário
          @expiration_time = timezone.at(expiration_time_utc.to_i).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")      
      else
          cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
          create_and_store_payment_member
      end
    else
        create_and_store_payment_member
    end
    # Antigo pagamento pix
    # payment_response = create_pix_payment(@member, (params[:quantity].to_i * @lottery.price.to_f).round(2))
    
    # if payment_response.code == 201
    #   parsed_response = payment_response.parsed_response
    #   @qr_code_base64 = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code_base64")
    #   @qr_code = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code")
    #   @id = parsed_response.dig("id")
      
    # else
    #   logger.error "Payment response error: #{payment_response.inspect}"
    #   render :purchase
    # end
    
  end 

  def create_and_store_payment_member
    payment_response = create_pix_payment(@member, (params[:quantity].to_i * @lottery.price.to_f).round(2))
    if payment_response.code == 201
      parsed_response = payment_response.parsed_response
      payment_id = parsed_response.dig("id")
      if payment_id
        expires_at = 10.minutes.from_now
        cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7] = { value: payment_id, expires: 10.minutes.from_now, secure: Rails.env.production?, httponly: true }
        # cookies[:payment_expires_at] = { value: expires_at.to_i, expires: expires_at, secure: Rails.env.production?, httponly: true }
      end
      @qr_code_base64 = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code_base64")
      @qr_code = parsed_response.dig("point_of_interaction", "transaction_data", "qr_code")
      @id = parsed_response.dig("id") 
      @status = parsed_response.dig("status")
    
      date_of_expiration_string = parsed_response.dig("date_of_expiration")
      # Converte a string para um objeto Time (ou DateTime)
      expiration_time = Time.iso8601(date_of_expiration_string)
      # Converte a hora para UTC
      expiration_time_utc = expiration_time.utc
      
      # Ajusta para o novo fuso horário (-03:00)
      # O novo fuso horário pode ser configurado diretamente com ActiveSupport::TimeZone
      timezone = ActiveSupport::TimeZone['Brasilia']  # Representa UTC-03:00
      
      # Converte o tempo UTC para o novo fuso horário
      @expiration_time = timezone.at(expiration_time_utc.to_i).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")      


      puts @status
      
      unless Transaction.find_by(transaction_id: @id)
        @transaction = Transaction.new(
          lottery_id:  @lottery.id,
          member_id: @member.id,
          transaction_id: @id,
          quantity: @numbers_count.to_i,
          status: @status,
          expiration_time: (Time.now + 10*60).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
        )
        @transaction.save

      end

    else
      logger.error "Payment response error: #{payment_response.inspect}"
      redirect_to error_path
    end
  end

  def check_payment
    payment_id = params[:payment_id]
    access_token = ENV.fetch("MERCADO_PAGO_ACCESS_TOKEN")
    
    
    # URL da API do Mercado Pago para consultar um pagamento específico
    url = "https://api.mercadopago.com/v1/payments/#{payment_id}"
    
    # Headers da requisição
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{access_token}"
    }


    # Realizar a requisição GET para consultar o pagamento
    response = HTTParty.get(url, headers: headers)
    
    # Retornar a resposta da API
    render json: response.body
  end 

  def capture_payment_pix(payment_id)
    access_token = ENV.fetch("MERCADO_PAGO_ACCESS_TOKEN")
  
    # URL da API do Mercado Pago para capturar um pagamento
    url = "https://api.mercadopago.com/v1/payments/#{payment_id}/capture"
  
    # Headers da requisição
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{access_token}"
    }
  
    # Realizar a requisição POST para capturar o pagamento
    response = HTTParty.post(url, headers: headers)
  
    # Retornar a resposta da API
    response
  end


  def create_pix_payment(member, amount)
      
    # Calcula a data de expiração
    expiration_time = Time.now + 10 * 60
    expiration_time += 1.hour
    # precisa ser igual 2024-06-05T17:48:49.105-04:00

    expiration_time = (Time.now + 10*60).strftime("%Y-%m-%dT%H:%M:%S.%L%:z")
    
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

    access_token = ENV.fetch("MERCADO_PAGO_ACCESS_TOKEN")

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
      'Authorization' => "Bearer #{access_token}",
      'X-Idempotency-Key' => idempotency_key
    }

    # Realizar a requisição POST para criar o pagamento
    response = HTTParty.post(url, headers: headers, body: payment_data.to_json)
    
    # Retornar a resposta da API
    response
  end

  def term
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    end
  end 

  def numbers
    require 'date'
    cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    @numbers =  params[:numbers].split(',')
    @member = Member.find(params[:yek])
  end 

  def search_numbers
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7].present?
      cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    end
  
    @member = Member.find(params[:yek])
    @whatsapp = SocialNetwork.find_by(slug: "whatsapp")
    @lotteries = Lottery.all
    @transactions = Transaction.where(member_id: @member.id).order(created_at: :desc)

    Parallel.each(@transactions, in_threads: 5) do |transaction|
      response = JSON.parse(check_transaction(transaction.transaction_id).body)
    
      if transaction.status != response.dig("status")
        transaction.update(status: response.dig("status"))
      end

      if transaction.expiration_time.present? && transaction.expiration_time < Time.current && transaction.status == "pending"
        transaction.update(status: "cancelled")
      end
    end
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

  def create_after_approved
    @lottery = Lottery.find(params[:lottery_id])
    @member = Member.find(params[:member_id])
    numbers_count = params[:quantity].to_i
    @transaction = Transaction.find_by(transaction_id: params[:transaction_id])
    @all_numbers = []
    @all_numbers = verificar_numeros_participantes(Member.where("tickets @> ?", { @lottery.id.to_s => [] }.to_json), @lottery.id).flatten
    
    @payment = Payment.new(
    lottery_id: params[:lottery_id],
    member_id: params[:member_id],
    transaction_id: params[:transaction_id],
    quantity: params[:quantity].to_i
    ) 
    @payment.save

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
      # render json: {
      #   "numbers": selected_numbers,
      #   "timestamp": @payment.created_at
      # }
      formatted_string = selected_numbers.join(',')
      redirect_to numbers_after_approved_path(numbers: formatted_string, yek: @member.id, timestamp: @transaction.created_at), notice: "Números selecionados com sucesso!"
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

  def comunications
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    end
    @comunications = Message.all
  end 

  def winners
    if cookies[:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7]
      cookies.delete(:qweqwieuyqwiueyqiweyqasdasdasqweqweqasdasdqweqweqwasdqweiuqweuq65q4weq9w8e7q987eas65dqw98e7q9we7as8d7a9sd7q9w8e7)
    end
    @winners = Lottery.where.not(winner: [nil, ""])
  end

  
  

  helper_method :contar_numeros
end