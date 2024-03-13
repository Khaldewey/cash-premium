class BannerCategory < ApplicationRecord
  has_many :banners, dependent: :destroy

  attr_readonly :name

  validates :name, presence: :true, uniqueness: true
  validates :image_width, presence: true, numericality: true
  validates :image_height, presence: true, numericality: true

  accepts_nested_attributes_for :banners, allow_destroy: true

end