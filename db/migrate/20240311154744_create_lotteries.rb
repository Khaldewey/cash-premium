class CreateLotteries < ActiveRecord::Migration[5.2]
  def change
    create_table :lotteries do |t|
      t.string :event
      t.datetime :date_event
      t.timestamps
    end
  end
end
