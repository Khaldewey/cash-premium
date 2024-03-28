class AddTicketsOnMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :tickets, :jsonb, default: {} 
  end
end
