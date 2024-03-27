class Member::HomeController < Member::ApplicationController
  def index
    
    @lotteries = Lottery.where(status: true)
  end
  
  def new
    @lottery = Lottery.find(params[:id])
    @member = current_member 
  end

  def create
    @lottery = Lottery.find(params[:id])
    @member = current_member 
    numbers_count = params[:member][:quantity].to_i

    if @member.tickets == nil
      selected_numbers = (1..@lottery.ticket).to_a.sample(numbers_count)
      @member.lottery_id = @lottery.id
      @member.tickets ||= {} 
      @member.tickets[@lottery.id] ||= [] 
      @member.tickets[@lottery.id] += selected_numbers
    else 
      selected_numbers = (1..@lottery.ticket).to_a.sample(numbers_count)
      @member.tickets[@lottery.id.to_s].concat(selected_numbers)
    end
    
    
    if @member.save
      redirect_to member_root_path, notice: "Números selecionados com sucesso!"
    else
      render :new
    end
  end
  

end
