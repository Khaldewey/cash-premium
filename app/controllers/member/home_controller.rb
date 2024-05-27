class Member::HomeController < Member::ApplicationController
  def index
    @lotteries = Lottery.where(status: true)
    # if @lotteries.present?
    #   @members = Member.where(lottery_id: @lotteries.first.id)
    #   @tickets = contar_numeros(@members)
    # end
    
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
    @lottery = Lottery.find(params[:id])
    @member = current_member 
    numbers_count = params[:member][:quantity].to_i
    @all_numbers = []
    @all_numbers = verificar_numeros_participantes(Member.where("tickets @> ?", { @lottery.id.to_s => [] }.to_json), @lottery.id).flatten
    #Aqui entra o método para verificar se o pagamento foi efetuado
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
        # -raise
      end
    end
    
    
    if @member.save
      render :pix
      # begin
      #   # Configuração pagamento pix
      #   mercado_pago_service = MercadoPagoService.new('TEST-191553553627645-052119-e02f16e5c678bc716b9d93cfcdba8d03-472243321')
      #   -raise
      #   preference = mercado_pago_service.create_pix_preference(@member, @lottery, params[:member][:quantity].to_i * 1.0)
        
      #   if preference[:qr_code_url].present?
      #     @member.update(qr_code_url: preference[:qr_code_url])
      #     redirect_to member_root_path, notice: "Números selecionados com sucesso! Utilize o QR code para o pagamento."
      #   else
      #     @member.tickets = {}
      #     redirect_to new_member_path, alert: "Erro ao gerar o QR code para pagamento. Tente novamente."
      #   end
      # rescue => e
      #   @member.tickets = {}
      #   redirect_to new_member_path, alert: "Erro ao processar o pagamento: #{e.message}. Tente novamente."
      # end
      redirect_to member_root_path, notice: "Números selecionados com sucesso!"
    else
      render :new
    end
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

  helper_method :contar_numeros

end
