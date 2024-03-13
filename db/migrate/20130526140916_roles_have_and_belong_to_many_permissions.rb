class RolesHaveAndBelongToManyPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions_roles, id: false do |t|
      t.references :permission, :role
    end

    add_index :permissions_roles, [:permission_id, :role_id], unique: true
    add_foreign_key :permissions_roles, :roles
    add_foreign_key :permissions_roles, :permissions
  end
end
