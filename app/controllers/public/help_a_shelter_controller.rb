class Public::HelpAShelterController < Public::ApplicationController
  respond_to :html, :js

  caches_action :index, :expires_in => 1.hour
  # caches_action :show, :expires_in => 2.minutes
  
  def index
  end
  
  def show
    @shelter = Shelter.active.find(params[:id])
    @items = @shelter.items.select(:name).all
  end
  
  def find_shelters_in_bounds
    @shelters = Shelter.find(:all, :conditions => {:status => "active"}, :bounds => [params[:filters][:sw],params[:filters][:ne]]).paginate(:per_page => 15, :page => params[:page])
  end
  
  def find_animals_for_shelter
    # Removed because it was redundant    shelter_id = Shelter.find(params[:filters][:shelter_id]).id
    shelter_id = params[:filters][:shelter_id]
    @animals = Animal.community_animals(shelter_id, params[:filters]).available_for_adoption.paginate(:per_page => 15, :page => params[:page]) || {}
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid shelter => #{params[:id]}")
    flash[:error] = "You have requested a shelter that is no longer listed!"
    redirect_to public_help_a_shelter_index_path, :status => :moved_permanently
  end

end


# @types = AnimalType.available_for_adoption_types(@shelter.id)