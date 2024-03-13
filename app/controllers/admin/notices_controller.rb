class Admin::NoticesController < Admin::ResourceController
  belongs_to :notice_category, parent_class: NoticeCategory


  def search
    @collection = parent.notices
    @collection = @collection.where('title LIKE ?', "%#{params[:search][:title]}%") if params[:search][:title].present?
    if params[:search][:published_at].present?
      @collection = @collection.where("DATE(published_at) = ?", params[:search][:published_at].to_date.to_s)
    end
    @collection = @collection.order(published_at: :desc).paginate(:page => params[:page])
    render :index
  end

  def update
    update! { collection_url }
  end

  def show
    @notice = Notice.find_by_slug(params[:id])
  end

  def is_active
    @notice = Notice.find_by_slug(params[:slug])
    if @notice.is_active == false
      @notice.update_attribute(:is_active, true)
    elsif @notice.is_active == true
      @notice.update_attribute(:is_active, false)
    end
    redirect_to admin_notice_category_notices_path(@notice.notice_category)
  end

  def is_highlight
    @notice = Notice.find_by_slug(params[:slug])
    if @notice.is_highlight == false
      @notice.update_attribute(:is_highlight, true)
    elsif @notice.is_highlight == true
      @notice.update_attribute(:is_highlight, false)
    end
    redirect_to admin_notice_category_notices_path(@notice.notice_category)
  end
end
