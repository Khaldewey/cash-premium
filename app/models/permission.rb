class Permission < ApplicationRecord
  validates :object_type, presence: true, uniqueness: { scope: :action_name }

  ACTIONS = { 'Adicionar' => 'create', 'Editar' => 'update', 'Visualizar' => 'read', 'Remover' => 'destroy' }

  has_and_belongs_to_many :roles

  belongs_to :entity

  def to_s
    description
  end
end
