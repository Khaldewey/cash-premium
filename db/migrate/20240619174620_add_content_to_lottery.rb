class AddContentToLottery < ActiveRecord::Migration[5.2]
  def change
    add_column :lotteries, :content, :string
  end
end
