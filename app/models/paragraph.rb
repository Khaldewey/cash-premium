class Paragraph < ApplicationRecord
    belongs_to :paragraphable, polymorphic: true

    before_save :check_youtube_video_id
    
    default_scope { order(created_at: :asc) }
    
    mount_uploader :image, ParagraphUploader
  
    def video_image(size, video=nil)
      if video.nil?
        "http://img.youtube.com/vi/#{self.youtube_video_id}/#{size}.jpg"
      end    
    end
  
    def check_youtube_video_id
      if self.videoparagrafo_changed?
        self.youtube_video_id = begin
          hash = self.videoparagrafo.scan /(youtu\.be\/|youtube\.com\/(watch\?(.*&)?v=|(embed|v)\/))([^\?&"'>]+)/
          hash.last.last if hash.present?
        end
      end
    end
end
