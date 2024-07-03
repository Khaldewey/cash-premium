class Frontend::ApplicationController < ActionController::Base
  before_action :initializers
  protect_from_forgery
  layout 'frontend'

  def initializers
    # @social_network = SocialNetwork.all
    # email_category = EmailCategory.find_by_name('Contato')
    # @email = email_category.email_contacts.first
    # @phone = Phone.last
    # @localization = Localization.first if present?
    # @whatsapp = SocialNetwork.find_by_name('Whatsapp')
    # @servico = ServiceCategory.order(created_at: :asc).all
    @phone = SocialNetwork.find_by(slug: "wathsapp")
  end
end
