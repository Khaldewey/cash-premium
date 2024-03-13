class CreatePageImages < ActiveRecord::Migration[5.2]
  def change
    create_table :page_images do |t|
      t.string :image
      t.string :title
      t.integer :position
      t.references   :page
      t.timestamps
    end
    add_foreign_key :page_images, :pages
  end
end
