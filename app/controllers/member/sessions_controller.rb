class Member::SessionsController < Devise::SessionsController
  layout 'login'
  def new
    super
  end
end