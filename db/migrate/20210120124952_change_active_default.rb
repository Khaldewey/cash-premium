class ChangeActiveDefault < ActiveRecord::Migration[5.2]
  def up
    change_column :notices, :is_active, :boolean, using: 'is_active::boolean', default: false
  end
  def down
    change_column :notices, :is_active, :boolean, using: 'is_active::boolean'
  end
end
