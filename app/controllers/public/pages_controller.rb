class Public::PagesController < Public::ApplicationController
  respond_to :html, :xml
  
  # caches_page :index, :show, :sitemap
    
  def index
    @animals = Animal.includes(:shelter).adopted.order(:status_change_date).limit(3)
  end
  
  def show
    @path = params[:path]
    template = File.join('public/pages', @path)    # About/FAQ page /about/faq.html.erb
    template_with_index = template + "/index"      # About Page /about/index.html.erb
    render :template => template rescue render :template => template_with_index rescue redirect_to "/404.html"
  end
  
  def sitemap
    @save_a_life_last_updated = Animal.order(:updated_at).first.updated_at.strftime("%Y-%m-%d")
    @animals = Animal.select("id, updated_at").available_for_adoption.all
  end
  
end



