class CreateParagraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :paragraphs do |t|
      t.text :content
      t.string :image
      t.string :videoparagrafo
      t.string :youtube_video_id
      t.belongs_to :paragraphable, polymorphic: true

      t.timestamps null: false
    end
    
    add_index :paragraphs, [:paragraphable_id, :paragraphable_type]
  end
end
