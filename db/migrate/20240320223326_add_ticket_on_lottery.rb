class AddTicketOnLottery < ActiveRecord::Migration[5.2]
  def change
    add_column :lotteries, :ticket, :integer
  end
end
