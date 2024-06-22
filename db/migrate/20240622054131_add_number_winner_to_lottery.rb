class AddNumberWinnerToLottery < ActiveRecord::Migration[5.2]
  def change
    add_column :lotteries, :number_winner, :integer
  end
end
