class Member::RegistrationsController < Devise::RegistrationsController
  layout 'login'

  before_action :defaults

  def defaults
  end

  

  def sign_up_params
    params.require(:member).permit(:email, :password, :password_confirmation, :name, :phone)
  end

end
