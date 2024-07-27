class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :status
      t.integer :quantity
      t.bigint :transaction_id
      t.references :lottery, index: true, foreign_key: true
      t.references :member, index: true, foreign_key: true
      t.timestamps
    end
  end
end
