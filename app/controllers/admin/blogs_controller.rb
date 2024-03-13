class Admin::BlogsController < Admin::ResourceController
    def search
        @collection = Blog.all
        @collection = @collection.where('title LIKE ?', "%#{params[:search][:title]}%") if params[:search][:title].present?
        @collection = @collection.where('DATE(published_at) = ?', params[:search][:published_at].to_date.to_s) if params[:search][:published_at].present?
        @collection = @collection.order(published_at: :desc).paginate(:page => params[:page])
        
        render :index
    end

    def show
        @blog = Blog.find_by_id(params[:id])
    end
    
end
