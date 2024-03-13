class PageImage < ApplicationRecord
  include Positionable

  belongs_to :page

  validates :image, presence: :true
  validates :page, presence: true

  default_scope { order(position: :asc) }

  before_validation :set_position, on: :create

  mount_uploader :image, DefaultUploader
end
