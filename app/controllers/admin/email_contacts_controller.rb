class Admin::EmailContactsController < Admin::ResourceController
  belongs_to :email_category, parent_class: EmailCategory

  def update
    update! { collection_url }
  end
end