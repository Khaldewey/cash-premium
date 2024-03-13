class AddFieldBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :banners, :position, :integer
  end
end
