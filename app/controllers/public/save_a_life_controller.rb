class Public::SaveALifeController < Public::ApplicationController
  respond_to :html, :js
  
  caches_action :index, :expires_in => 1.hour
  # caches_action :show, :expires_in => 2.minutes
  
  def index
  end
  
  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter).find(params[:id])
    @shelter = @animal.shelter
    raise ActiveRecord::RecordNotFound if @shelter.inactive?
  end
  
  def find_animals_in_bounds
    shelter_ids = Shelter.find(:all, :conditions => {:status => "active"}, :bounds => [params[:filters][:sw],params[:filters][:ne]]).collect(&:id)
    unless shelter_ids.blank?
      @animals = Animal.community_animals(shelter_ids, params[:filters]).available_for_adoption.paginate(:per_page => 10, :page => params[:page]) || {}
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an animal that is no longer listed!"
    redirect_to public_save_a_life_index_path, :status => :moved_permanently
  end
  
end