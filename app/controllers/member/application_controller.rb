class Member::ApplicationController < ApplicationController#ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery

  before_action :defaults, :authenticate_member!

  layout 'member'

  WillPaginate.per_page = 10

  def defaults
   
  end

end
