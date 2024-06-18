class Member < ApplicationRecord
  validates :email,:name,:phone,:cpf, presence: :true

  def self.find_by_ticket(ticket_number, lottery_id)
    all.each do |member|
      tickets = member.tickets[lottery_id.to_s]
      return member if tickets && tickets.include?(ticket_number)
    end
    nil
  end
end
