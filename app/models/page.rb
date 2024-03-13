class Page < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  attr_readonly :title

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true

  has_many :page_images, dependent: :destroy

  accepts_nested_attributes_for :page_images, allow_destroy: true
end
