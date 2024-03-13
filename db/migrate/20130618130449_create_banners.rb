class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.string       :image
      t.string       :link
      t.references   :banner_category
      t.datetime     :expires_at

      t.timestamps
    end

    add_index :banners, :expires_at
    add_foreign_key :banners, :banner_categories
  end
end
