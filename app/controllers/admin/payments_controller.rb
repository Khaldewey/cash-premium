class Admin::PaymentsController < Admin::ResourceController 
  def search
    @collection = Payment.all

    if params[:search].present?
      if params[:search][:lottery_id].present?
        @collection = @collection.where(lottery_id: params[:search][:lottery_id])
      end
      if params[:search][:member_id].present?
        @collection = @collection.where(member_id: params[:search][:member_id])
      end
    end

    @collection = @collection.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
    render :index
  end

  def index
    @collection  = Payment.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end
end