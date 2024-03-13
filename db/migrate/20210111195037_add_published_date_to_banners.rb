class AddPublishedDateToBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :banners, :published_at, :datetime
  end
end
