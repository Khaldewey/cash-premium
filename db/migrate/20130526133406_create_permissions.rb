class CreatePermissions < ActiveRecord::Migration[5.2]
  def up
    create_table :permissions do |t|
      t.string :description
      t.string :object_type
      t.string :action_name
      t.timestamps
    end

    add_index :permissions, [:object_type, :action_name], unique: true
  end

  def down
    drop_table :permissions
  end
end
