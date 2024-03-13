class AddFieldImage < ActiveRecord::Migration[5.2]
  def change
     add_column :images, :position, :integer
  end
end
