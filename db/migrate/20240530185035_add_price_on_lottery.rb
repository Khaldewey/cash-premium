class AddPriceOnLottery < ActiveRecord::Migration[5.2]
  def change
    add_column :lotteries, :price, :integer
  end
end
