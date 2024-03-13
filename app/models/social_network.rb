class SocialNetwork < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  
  validates :name, :url, presence: true
  
  private
  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end  
end
