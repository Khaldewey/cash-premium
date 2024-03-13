class Frontend::ArticlesController < Frontend::ApplicationController
  def index
    @article_category = ArticleCategory.find_by(slug: params[:article_category_slug])
    @articles = @article_category.articles if @article_category.present?
  end

  def show
    @article = Article.find_by(slug: params[:slug])
    render @article.slug
  end
end