class Public::PagesController < Public::ApplicationController
  respond_to :html, :xml
  
  # caches_action :index, :expires_in => 1.hour
  # caches_action :show
    
  def index
    @animals = Animal.latest(:adopted, 3).all
    @lives_saved = Animal.adopted.limit(nil).count + Animal.transferred.limit(nil).count + Transfer.completed.limit(nil).count
    @active_shelters = Shelter.active.count
  end
  
  def show
    @path = params[:path]
    template = File.join('public/pages', @path)    # About/FAQ page /about/faq.html.erb
    template_with_index = template + "/index"      # About Page /about/index.html.erb
    render :template => template rescue render :template => template_with_index rescue render :file => "#{Rails.root}/public/404.html", :layout => false, :status => 404
  end
  
  def sitemap
    # Move to models
    @animals = Animal.select("animals.id, animals.updated_at").joins(:shelter).where(:shelters => { :status => "active"}).available_for_adoption.limit(nil).all
    @save_a_life_last_updated = Animal.order(:updated_at).first.updated_at.strftime("%Y-%m-%d")
    
    @shelters = Shelter.select([:id, :updated_at]).active.all
    @help_a_shelter_last_updated = Shelter.active.order("updated_at DESC").first.updated_at.strftime("%Y-%m-%d")
  end
  
end



