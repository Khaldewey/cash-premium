class AddStatusToLottery < ActiveRecord::Migration[5.2]
  def change
    add_column :lotteries, :status, :boolean
  end
end
