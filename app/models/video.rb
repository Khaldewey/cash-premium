class Video < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]
  before_save :check_youtube_video_id
 
  validates :title, presence: true, uniqueness: true
  validates :link, presence: true
   
  default_scope { order(created_at: :desc) }

  def image size
    "https://img.youtube.com/vi/#{self.youtube_video_id}/#{size}.jpg"
  end

  private
  def check_youtube_video_id
    if self.link_changed?
      self.youtube_video_id = begin
        hash = self.link.scan /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
        hash.last.last
      end
    end
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
