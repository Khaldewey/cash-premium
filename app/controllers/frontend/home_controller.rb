class Frontend::HomeController < Frontend::ApplicationController
  def index
    @page_about = Page.find_by_title('Quem Somos')
    @page_valor = Page.find_by_title('Valores')
    @page_mission = Page.find_by_title('Missão')
    @page_vision = Page.find_by_title('Visão')
  end

  def create_newsletter
    @newsletter = Newsletter.new(params[:newsletter])

    if @newsletter.save
      redirect_to root_url, :notice => 'Newsletter cadastrado com sucesso.'
    else
      render :index
    end
  end
end
