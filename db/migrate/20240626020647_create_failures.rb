class CreateFailures < ActiveRecord::Migration[5.2]
  def change
    create_table :failures do |t|
      t.references :payment, index: true, foreign_key: true
      t.references :member, index: true, foreign_key: true
      t.timestamps
    end
  end
end
