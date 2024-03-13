class AddYoutubeVideoIdAndSlug < ActiveRecord::Migration[5.2]
  def change
  	add_column :videos, :slug, :string
    add_column :videos, :youtube_video_id, :string
  end
end
