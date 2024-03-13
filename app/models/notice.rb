class Notice < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: [:slugged, :finders]
    before_save :check_youtube_video_id
  
    stringify :published_at, format: '%d/%m/%Y'
  
    validates :title, :cover_image, :published_at_string,  presence: true
    validates :subtitle_cover_image, length: { maximum: 255 }
  
    has_many :paragraphs, as: :paragraphable, dependent: :destroy
  
    accepts_nested_attributes_for :paragraphs, allow_destroy: true
  
    belongs_to :notice_category
  
    mount_uploader :cover_image, NoticeUploader
    mount_uploader :content_audio, AudioUploader
    mount_uploader :audio, AudioUploader
  
    def video_image(size, video=nil)
      if video.nil?
        "http://img.youtube.com/vi/#{self.youtube_video_id}/#{size}.jpg"
      end
    end
  
    private
    def should_generate_new_friendly_id?
      slug.blank? || title_changed?
    end
  
    def check_youtube_video_id
      if self.video_url_changed?
        self.youtube_video_id = begin
          hash = self.video_url.scan /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
          hash.last.last if hash.present?
        end
      end
    end
  end
  