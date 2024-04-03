class Member::HomeController < Member::ApplicationController
  def index
    @lotteries = Lottery.where(status: true)
    if @lotteries.present?
      @members = Member.where(lottery_id: @lotteries.first.id)
      @tickets = contar_numeros(@members)
    end
    # -raise
  end 

  def contar_numeros(membros)
    total_numeros = 0
    membros.each do |membro|
      if membro[:tickets].empty?
        break
      else
        total_numeros += membro[:tickets][membro.lottery_id.to_s].count
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
    @all_numbers = verificar_numeros_participantes(Member.all).flatten
    
    -raise
    if @member.tickets == nil || @member.tickets.empty?
      selected_numbers = []
      while selected_numbers.length < numbers_count do
        new_number = (1..@lottery.ticket).to_a.sample
        selected_numbers << new_number unless selected_numbers.include?(new_number)
      end
      @member.lottery_id = @lottery.id
      @member.tickets ||= {} 
      @member.tickets[@lottery.id] ||= [] 
      @member.tickets[@lottery.id] += selected_numbers
      # -raise
    else
      
      if @member.tickets.keys.first.to_i == @lottery.id
        
        selected_numbers = (1..@lottery.ticket).to_a.sample(numbers_count)
        selected_numbers.each_with_index do |number, index|
          if @member.tickets[@lottery.id.to_s].include?(number)
            available_numbers = ((1..@lottery.ticket).to_a - @member.tickets[@lottery.id.to_s])
            new_number = available_numbers.sample(1).first
            selected_numbers[index] = new_number  # Substitui o número existente pelo novo número
          end
        end
        @member.tickets[@lottery.id.to_s].concat(selected_numbers)
         
      else
        selected_numbers = []
        while selected_numbers.length < numbers_count do
          new_number = (1..@lottery.ticket).to_a.sample
          selected_numbers << new_number unless selected_numbers.include?(new_number)
        end
        @member.lottery_id = @lottery.id
        @member.tickets[@lottery.id] ||= [] 
        @member.tickets[@lottery.id] += selected_numbers
      end
    end
    
    
    if @member.save
      redirect_to member_root_path, notice: "Números selecionados com sucesso!"
    else
      render :new
    end
  end
  
  def verificar_numeros_participantes(membros)
    flag_array = []
    membros.each do |membro|
      flag_array << membro.tickets.values.flatten
    end
    return flag_array
  end

end
