class Tutorial < ApplicationRecord
    validates :title, :file, presence: true

	mount_uploader :file, TutorialUploader
end
