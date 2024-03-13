class Contact
  include ActiveModel::Model
  
  attr_accessor :name, :email, :comment, :phone
  
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ }
  validates :comment, presence: true, length: { maximum: 800 }

  def persisted?
    false
  end
end
