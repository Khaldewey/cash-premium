class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :image
      t.string :title
      t.belongs_to :imageable, polymorphic: true

      t.timestamps
    end

    add_index :images, [:imageable_id, :imageable_type]
  end
end
