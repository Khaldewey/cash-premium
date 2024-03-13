class Admin::ArticlesController < Admin::ResourceController
  belongs_to :article_category, parent_class: ArticleCategory

  def update
    update! { collection_url }
  end
end