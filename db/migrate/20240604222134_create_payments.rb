class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :status
      t.datetime :expiration_date
      t.bigint :transaction_id
      t.references :lottery, index: true, foreign_key: true
      t.references :member, index: true, foreign_key: true
      t.timestamps
    end
  end
end
