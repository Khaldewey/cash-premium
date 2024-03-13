class ChangeNoticeActive < ActiveRecord::Migration[5.2]
  def change
    change_column :notices, :is_active, :boolean, using: 'is_active::boolean'
  end
end
