class DefaultMailer < ActionMailer::Base
  include SendGrid

  email_category = EmailCategory.find_by(name: 'Contato')
  emails = email_category.email_contacts if email_category.present?

  default to: emails.first.email if emails.present?
  
  def contact(contact)
    @contact = contact
    sendgrid_category "Contato   "
    mail subject: 'Contato do Site',
      from: @contact.email
  end
end
