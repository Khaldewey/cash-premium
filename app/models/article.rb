# encoding: UTF-8
class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  stringify :published_at, format: '%d/%m/%Y %H:%M:%S'

  has_many :images, as: :imageable, dependent: :destroy

  belongs_to :article_category

  validates :title, presence: true
  validates :content, presence: true
  validates :published_at_string, presence: true

  accepts_nested_attributes_for :images, allow_destroy: true

  private
  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
