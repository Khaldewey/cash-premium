class Member::RegistrationsController < Devise::RegistrationsController
  layout 'login'

  before_action :defaults

  def defaults
  end

  def create
    super 
      if resource.persisted?
        # Se o cadastro foi bem-sucedido e o contexto for 'comprar-bilhete', redirecione para a página de validação de pagamento com o ID da loteria
        if params[:context] == 'comprar-bilhete' && params[:lottery_id].present?
          redirect_to member_validar_pagamento_path(id: params[:lottery_id])
        else
          # Se não houver contexto específico ou ID da loteria presente, redirecione para algum lugar padrão
          redirect_to member_root_path
        end
      end
  end

  private
  def account_update_params
    params.require(:member).permit(:name, :email, :phone, :password, :password_confirmation, :current_password)
  end 

  def sign_up_params
    params.require(:member).permit(:email, :password, :password_confirmation, :name, :phone)
  end

end
