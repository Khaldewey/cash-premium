class MembroCliente::EditPasswordController < MembroCliente::ApplicationController
  #load_and_authorize_resource :membro_cliente

  def update
    if params[:member][:password].blank?
      params[:member].delete(:password)
      params[:member].delete(:password_confirmation)
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
    params.require(:member).permit(:password, :password_confirmation)
  end

end
