class MembroCliente::EditPasswordController < MembroCliente::ApplicationController
  #load_and_authorize_resource :membro_cliente

  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    update! { collection_path }
  end

  def new
    @member = current_member
    #authorize! :edit_password, @member
  end

  def update_password
    @member = Member.find(current_member.id)

    if @member.update(member_params)
      sign_in @member, :bypass => true
      redirect_to member_root_path
    else
      render :new
    end
  end

  private
  def member_params
    params.require(:membro_cliente).permit(:password, :password_confirmation)
  end

end
