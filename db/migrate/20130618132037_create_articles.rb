class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string        :title
      t.string        :abstract
      t.text          :content
      t.datetime      :published_at
      t.references    :article_category
      t.string        :slug

      t.timestamps
    end

    add_index :articles, :slug, :unique => true
    add_foreign_key :articles, :article_categories
  end
end
