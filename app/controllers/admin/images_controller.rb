class Admin::ImagesController < Admin::PositionUpdaterController
  belongs_to :article_category, parent_class: ArticleCategory do
    belongs_to :article, parent_class: Article
  end

  def create
    @gallery = Article.find params[:article_id]

    @image = @gallery.images.build

    @image.image = params[:file]

    @image.save

    render nothing: true
  end

  def destroy
    destroy! { parent_url(parent)}
  end

  def update
    update! { parent_url(parent) }
  end

  
end