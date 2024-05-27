class AddQrCodeUrlToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :qr_code_url, :string
  end
end
