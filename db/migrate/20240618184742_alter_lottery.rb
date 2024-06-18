class AlterLottery < ActiveRecord::Migration[5.2]
  def change
    add_column :lotteries, :winner, :string
    add_column :lotteries, :image, :string
  end
end
