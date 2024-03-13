class Blog < ApplicationRecord

    validates :title,:content,:image,:published_at_string, presence: :true

    mount_uploader :image, DefaultUploader

    stringify :published_at, format: '%d/%m/%Y'
end
