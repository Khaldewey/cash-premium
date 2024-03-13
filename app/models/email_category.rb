class EmailCategory < ApplicationRecord
	validates :name, presence: true
	has_many :email_contacts, dependent: :destroy
end
