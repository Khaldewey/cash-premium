class AddUniqueConstraintToPhoneOnMembers < ActiveRecord::Migration[5.2]
  def change
    add_index :members, :phone, unique: true
  end
end
