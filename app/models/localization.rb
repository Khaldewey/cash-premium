class Localization < ApplicationRecord
	validates :address, presence: true

	mount_uploader :image, DefaultUploader
end
