class Public::PagesController < Public::ApplicationController
  respond_to :html, :xml
  
  # caches_page :index, :show, :sitemap
    
  def index
    @animals = Animal.latest(:adopted, 3).all
  end
  
  def show
    @path = params[:path]
    template = File.join('public/pages', @path)    # About/FAQ page /about/faq.html.erb
    template_with_index = template + "/index"      # About Page /about/index.html.erb
    render :template => template rescue render :template => template_with_index rescue redirect_to "/404.html"
  end
  
  def sitemap
    # Move to models
    @animals = Animal.select("animals.id, animals.updated_at").joins(:shelter).where(:shelters => { :status => "active"}).available_for_adoption.limit(nil).all
    @save_a_life_last_updated = Animal.order(:updated_at).first.updated_at.strftime("%Y-%m-%d")
    
    @shelters = Shelter.select([:id, :updated_at]).active.all
    @help_a_shelter_last_updated = Shelter.active.order("updated_at DESC").first.updated_at.strftime("%Y-%m-%d")
  end
  
end



