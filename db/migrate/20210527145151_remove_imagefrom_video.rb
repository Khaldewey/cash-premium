class RemoveImagefromVideo < ActiveRecord::Migration[5.2]
  def change
  	remove_column :videos, :image
  end
end
