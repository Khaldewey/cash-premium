class NoticeCategory < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: [:slugged, :finders]
  
    has_many :notices, dependent: :destroy
  
    private
    def should_generate_new_friendly_id?
      slug.blank? || name_changed?
    end  
end
