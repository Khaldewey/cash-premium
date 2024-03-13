class ArticleCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :articles, dependent: :destroy

  validates :name, presence: :true, uniqueness: true

  scope :active, -> { where(is_active: true) }

  private
  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
