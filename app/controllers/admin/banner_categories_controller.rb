class Admin::BannerCategoriesController < Admin::ResourceController
    def index
        @banners = BannerCategory.paginate(page: params[:page], per_page: 5)
      end
end
