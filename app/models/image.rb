class Image < ApplicationRecord
  include Positionable
  belongs_to :imageable, polymorphic: true

  validates :image, presence: true

  default_scope { order(position: :asc) }

  before_validation :set_position, on: :create

  mount_uploader :image, DefaultUploader

end
