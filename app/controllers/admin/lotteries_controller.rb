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
end