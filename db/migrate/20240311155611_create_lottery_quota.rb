class CreateLotteryQuota < ActiveRecord::Migration[5.2]
  def change
    create_table :lottery_quota do |t|
      t.references :lottery, index: true, foreign_key: true
      t.references :quota, index: true, foreign_key: true
      t.timestamps
    end
  end
end
