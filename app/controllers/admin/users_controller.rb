class Admin::UsersController < Admin::ResourceController
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    update! { collection_path }
  end

  def create
    
    if current_user.role.name != "Admin"

      user  = User.new(email: params[:user][:email], password: params[:user][:password], is_active: params[:user][:is_active])
      user.role = Role.where(name: 'Cliente').first    
      user.save  
      redirect_to collection_path

    else

      create! { collection_path } 

    end

  end

  def edit_password
    @user = current_user
    authorize! :edit_password, @user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      sign_in @user, :bypass => true
      redirect_to admin_root_path
    else
      render :edit_password
    end
  end

  def collection    
    if current_user.role.name != "Admin"
      collection = Role.where(name: 'Cliente').first.users
    else
      collection = User.all
    end

    collection.paginate(:page => params[:page])
  end
  
  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end