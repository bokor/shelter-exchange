class Public::PagesController < Public::ApplicationController
  respond_to :html, :xml
  
  # caches_page :index, :show, :sitemap
    
  def index
    @animals = Animal.latest(3).adopted.all
  end
  
  def show
    @path = params[:path]
    template = File.join('public/pages', @path)    # About/FAQ page /about/faq.html.erb
    template_with_index = template + "/index"      # About Page /about/index.html.erb
    render :template => template rescue render :template => template_with_index rescue redirect_to "/404.html"
  end
  
  def sitemap
    @animals = Animal.select([:id, :updated_at]).available_for_adoption.all
    @save_a_life_last_updated = Animal.order(:updated_at).first.updated_at.strftime("%Y-%m-%d")
    
    @shelters = Shelter.select([:id, :updated_at]).all
    @help_a_shelter_last_updated = Shelter.order("updated_at DESC").first.updated_at.strftime("%Y-%m-%d")
  end
  
end



