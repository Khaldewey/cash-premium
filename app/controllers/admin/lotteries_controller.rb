class Admin::LotteriesController < Admin::ResourceController
  def active_lottery
    @lottery = Lottery.find_by_id(params[:slug])
    if @lottery.status == false || @lottery.status == nil
      @lottery.update_attribute(:status, true)
    elsif @lottery.status == true
      @lottery.update_attribute(:status, false)
    end
    redirect_to admin_lotteries_path
  end  


  def to_rank
    @lottery = Lottery.find_by_id(params[:lottery_id])
    if @lottery.result == nil
      @all_numbers = []
      @all_numbers = verificar_numeros_participantes(Member.where("tickets @> ?", { @lottery.id.to_s => [] }.to_json), @lottery.id).flatten
      @lottery.result = @all_numbers.sample
      @lottery.save
    else
      @all_numbers = []
      @all_numbers = verificar_numeros_participantes(Member.where("tickets @> ?", { @lottery.id.to_s => [] }.to_json), @lottery.id).flatten
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
end