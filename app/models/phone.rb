class Phone < ApplicationRecord
	validates :phone, presence: true
end
