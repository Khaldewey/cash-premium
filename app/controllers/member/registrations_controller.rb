class Member::RegistrationsController < Devise::RegistrationsController
  layout 'member'

  before_action :defaults

  def defaults
  end

  private
  def account_update_params
    params.require(:member).permit(:name, :email, :phone, :password, :password_confirmation, :current_password)
  end 

end
