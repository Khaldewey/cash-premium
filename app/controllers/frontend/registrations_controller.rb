class Frontend::RegistrationsController < Frontend::ApplicationController
  def new
    @member = Member.new
  end 

  def new_member_payment
    @member = Member.new
    @lottery = Lottery.find(params[:lottery][:lottery_id].to_i)
    @numbers_count = params[:lottery][:quantity].to_i
    @phone = params[:lottery][:phone]
    # -raise 
  end

  def create_member_and_payment
    @member = Member.new(member_params)
    @lottery = Lottery.find(params[:lottery_id])
    respond_to do |format|
      if @member.save
        format.html { redirect_to validar_pagamento_path(id: @lottery.id, yek: @member.id, quantity: params[:quantity]), notice: 'Cadastro realizado com sucesso!' }
      else
        format.html { render :new }
        format.json { render json: { errors: @member.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotUnique => e
    handle_unique_error(e)
    render :new
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