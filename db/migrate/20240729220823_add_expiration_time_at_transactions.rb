class AddExpirationTimeAtTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :expiration_time, :datetime
  end
end
