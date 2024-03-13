class Frontend::ContactController < Frontend::ApplicationController
  def new
    @contact = Contact.new
  end

  def send_contact
    @contact = Contact.new(contact_params)

    if @contact.valid? && verify_recaptcha(model: @contact)
      DefaultMailer.contact(@contact).deliver
      redirect_to root_path+"#contact", :notice => 'Contato enviado com sucesso.'
    else
      redirect_to root_path+"#contact", :notice => 'Contato nao enviado.'
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:name,:email,:phone,:comment)
  end
end
