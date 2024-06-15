class EditPayment < ActiveRecord::Migration[5.2]
  def change
    remove_column :payments, :status
    remove_column :payments, :expiration_date

    add_column :payments, :quantity, :integer
  end
end
