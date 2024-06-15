class Member < ApplicationRecord
  validates :email,:name,:phone,:cpf, presence: :true
end
