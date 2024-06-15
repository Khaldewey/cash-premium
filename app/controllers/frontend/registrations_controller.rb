class Frontend::RegistrationsController < Frontend::ApplicationController
  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    respond_to do |format|
      if @member.save
        format.html { redirect_to root_path, notice: 'Cadastro realizado com sucesso!' }
      else
        format.html { render :new }
        format.json { render json: { errors: @member.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotUnique => e
    handle_unique_error(e)
    render :new
  end

  private

  def member_params
    params.require(:member).permit(:email, :name, :phone, :cpf)
  end

  def handle_unique_error(exception)
    if exception.message.include?('index_members_on_email')
      @member.errors.add(:email, 'já está cadastrado. Por favor, escolha outro.')
    elsif exception.message.include?('index_members_on_cpf')
      @member.errors.add(:cpf, 'já está cadastrado. Por favor, escolha outro.')
    elsif exception.message.include?('index_members_on_phone')
      @member.errors.add(:phone, 'já está cadastrado. Por favor, escolha outro.')
    end
  end
end