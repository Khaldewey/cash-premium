class AddIsActiveToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_active, :boolean, default: true
    add_column :users, :is_admin, :boolean, default: false

    add_index :users, :is_active
    add_index :users, :is_admin
  end
end
