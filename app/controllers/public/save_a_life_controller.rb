class Public::SaveALifeController < Public::ApplicationController
  respond_to :html, :js
  
  # caches_action :index
  # caches_action :show, :cache_path => Proc.new {|c| "save_a_life/#{c.params[:id]}" }
  
  def index
  end
  
  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter, :photos).find(params[:id])
    @shelter = @animal.shelter
    raise ActiveRecord::RecordNotFound if @shelter.inactive?    
    @photos = @animal.photos
    @gallery_photos = PhotoPresenter.as_gallery(@photos)
  end
  
  def find_animals_in_bounds
    shelter_ids = Shelter.find(:all, :select => :id, :conditions => {:status => "active"}, :bounds => [params[:filters][:sw],params[:filters][:ne]])
    unless shelter_ids.blank?
      @animals = Animal.community_animals(shelter_ids, params[:filters]).available.paginate(:page => params[:page], :per_page => 10).all || {}
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an animal that is no longer listed!"
    self.action_name = "index"
    render :action => :index, :status => 404
  end
  
end