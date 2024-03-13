class AddSizeToBannerCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :banner_categories, :image_width, :integer
    add_column :banner_categories, :image_height, :integer
  end
end
