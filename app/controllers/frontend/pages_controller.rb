class Frontend::PagesController < Frontend::ApplicationController
  def show
    @page = Page.find_by(slug: params[:slug])
  end
end
