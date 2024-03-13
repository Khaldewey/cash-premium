class CreateLocalizations < ActiveRecord::Migration[5.2]
  def change
    create_table :localizations do |t|
      t.string :link
      t.text :address
      t.string :image
      t.timestamps
    end
  end
end
