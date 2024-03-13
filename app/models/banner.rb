# encoding: UTF-8
class Banner < ApplicationRecord
  include Positionable
  stringify :expires_at, format: '%d/%m/%Y %H:%M:%S'
  stringify :published_at, format: '%d/%m/%Y %H:%M:%S'

  belongs_to :banner_category

  validates :image, presence: :true
  validates :banner_category, presence: true

  default_scope { order(position: :asc) }

  before_validation :set_position, on: :create

  mount_uploader :image, BannerUploader

end
