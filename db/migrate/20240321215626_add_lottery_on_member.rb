class AddLotteryOnMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :lottery, foreign_key: true
  end
end
