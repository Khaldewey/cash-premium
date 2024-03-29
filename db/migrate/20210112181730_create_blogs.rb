class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.string :title
      t.string :abstract
      t.text :content
      t.string :image
      t.datetime :published_at

      t.timestamps
    end
  end
end
