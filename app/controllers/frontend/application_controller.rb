class Frontend::ApplicationController < ActionController::Base
  before_action :initializers
  protect_from_forgery
  layout 'frontend'

  def initializers
    banner_category = BannerCategory.find_by_name('Banners')
    @banner = banner_category.banners
    @analytics = Analytic.last
    @social_network = SocialNetwork.first(3)
    @localization = Localization.first if present?
    @phone = Phone.last(2)
    email_category = EmailCategory.find_by_name('Contato')
    @email = email_category.email_contacts.first
    @contato = Contact.new
  end
end
