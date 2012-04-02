class Public::HelpAShelterController < Public::ApplicationController
  respond_to :html, :js

  # caches_action :index
  # caches_action :show, :expires_in => 2.minutes
  
  def index
  end
  
  def show
    @shelter = Shelter.active.find(params[:id])
    @items = @shelter.items.select(:name).all
  end
  
  def search_by_name
    q = params[:q]
    unless q.blank?
      q.strip.split.join("%")
      shelter_params = params[:shelters].delete_if{|k,v| v.blank?} if params[:shelters]
      @shelters = q.blank? ? {} : Shelter.live_search(q, shelter_params).paginate(:per_page => 15, :page => params[:page])
    end
  end
  
  # def live_search
  #   q = params[:q].strip.split.join("%")
  #   shelter_params = params[:shelters].delete_if{|k,v| v.blank?} if params[:shelters]
  #   @shelters = q.blank? ? {} : Shelter.live_search(q, shelter_params).paginate(:per_page => 15, :page => params[:page])
  # end
  
  def find_shelters_in_bounds
    @shelters = Shelter.find(:all, :conditions => {:status => "active"}, :bounds => [params[:filters][:sw],params[:filters][:ne]]).paginate(:per_page => 15, :page => params[:page])
  end
  
  def find_animals_for_shelter
    shelter_id = params[:filters][:shelter_id]
    @animals = Animal.community_animals(shelter_id, params[:filters]).available_for_adoption.paginate(:per_page => 15, :page => params[:page]) || {}
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid shelter => #{params[:id]}")
    flash[:error] = "You have requested a shelter that is no longer listed!"
    self.action_name = "index"
    render :action => :index, :status => 404
  end

end

# def find_animals_for_shelter
  # Removed because it was redundant    shelter_id = Shelter.find(params[:filters][:shelter_id]).id

# @types = AnimalType.available_for_adoption_types(@shelter.id)