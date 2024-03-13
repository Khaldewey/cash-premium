class CreateNotices < ActiveRecord::Migration[5.2]
  def change
    create_table :notices do |t|
      t.string :title
      t.string :slug
      t.string :abstract
      t.text :content
      t.datetime :published_at
      t.string :cover_image
      t.boolean :cover_image_body
      t.string :content_audio
      t.string :audio
      t.string :subtitle_cover_image
      t.boolean :is_highlight
      t.string :is_active
      t.string :video_url
      t.string :youtube_video_id
      t.references :notice_category, index: true, foreign_key: true

      t.timestamps
    end
  end
end
