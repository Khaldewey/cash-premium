class ChangePriceToFloatInLotteries < ActiveRecord::Migration[5.2]
  def change
    change_column :lotteries, :price, :float
  end
end
