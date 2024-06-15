class RemoveDeviseAndAddCpfToMembers < ActiveRecord::Migration[5.2]
  # Remove o Devise
  change_table :members do |t|
    t.remove :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  end

  # Adiciona o atributo cpf
  add_column :members, :cpf, :string
  add_index :members, :cpf, unique: true

  # Remove o atributo qr_code_url
  remove_column :members, :qr_code_url

  # Torna os campos phone e cpf únicos
  change_table :members do |t|
    t.remove_index :phone if index_exists?(:members, :phone)
    t.change :phone, :string, unique: true
  end
end

