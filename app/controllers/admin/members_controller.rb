class Admin::MembersController < Admin::ResourceController
    def search_by_ticket
        ticket_number = params[:ticket_number].to_i
        lottery_id = params[:lottery_id].to_i # Obtém o lottery_id dos parâmetros
        member = Member.find_by_ticket(ticket_number, lottery_id)
        
        if member
            render json: { success: true, member: member.name, cpf: member.cpf, phone: member.phone, email: member.email}
        else
            render json: { success: false, message: 'Membro não encontrado' }
        end
    end

    def index
        @members = Member.paginate(page: params[:page], per_page: 8)
    end
end