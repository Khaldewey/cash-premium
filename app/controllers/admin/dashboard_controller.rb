class Admin::DashboardController < Admin::ApplicationController
  def index
    @banners_count = Banner.count
    @pages_count = Page.count
    @category_articles_count = ArticleCategory.count
    @articles_count = Article.count
  end
end
