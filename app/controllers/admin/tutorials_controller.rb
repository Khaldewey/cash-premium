class Admin::TutorialsController < Admin::ResourceController
    def search
        @collection = Tutorial.all
        @collection = @collection.where('title LIKE ?', "%#{params[:search][:title]}%") if params[:search][:title].present?
        @collection = @collection.order(created_at: :desc).paginate(:page => params[:page])
        render :index
    end
end
