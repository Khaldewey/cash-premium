class Admin::BannersController < Admin::PositionUpdaterController
  belongs_to :banner_category, parent_class: BannerCategory

  def index
    @banners = Banner.paginate(page: params[:page], per_page: 5)
  end

  def create
    @gallery = BannerCategory.find params[:banner_category_id]

    @image = @gallery.banners.build

    @image.image = params[:file]

    @image.save

    render nothing: true
  end

  def destroy
    destroy! { parent_path }
  end

  def update
    update! { resource_path }
  end
  
end
