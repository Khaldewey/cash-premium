class CreateQuota < ActiveRecord::Migration[5.2]
  def change
    create_table :quota do |t|
      t.boolean :purchased
      t.integer :ticket
      t.timestamps
    end
  end
end
