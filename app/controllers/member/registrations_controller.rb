class Member::RegistrationsController < Devise::RegistrationsController
  layout 'login'

  before_action :defaults

  def defaults
  end

  private
  def account_update_params
    params.require(:member).permit(:name, :email, :phone, :password, :password_confirmation, :current_password)
  end 

  def sign_up_params
    params.require(:member).permit(:email, :password, :password_confirmation, :name, :phone)
  end

end
