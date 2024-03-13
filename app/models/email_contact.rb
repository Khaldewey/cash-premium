class EmailContact < ApplicationRecord
	validates :email, presence: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
	belongs_to :email_category
end
