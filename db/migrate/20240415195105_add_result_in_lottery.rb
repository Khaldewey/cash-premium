class AddResultInLottery < ActiveRecord::Migration[5.2]
  def change
    add_column :lotteries, :result, :integer
  end
end
