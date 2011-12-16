class Public::HelpAShelterController < Public::ApplicationController
  respond_to :html, :js
  
  def index
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    @items = @shelter.items.select(:name)
    # @types = AnimalType.available_for_adoption_types(@shelter.id)
  end
  
  def find_shelters_in_bounds
    @shelters = Shelter.find(:all, :bounds => [params[:filters][:sw],params[:filters][:ne]]).paginate(:per_page => 15, :page => params[:page])
  end
  
  def find_animals_for_shelter
    shelter_id = Shelter.find(params[:filters][:shelter_id]).id
    @animals = Animal.community_animals(shelter_id, params[:filters]).available_for_adoption.all.paginate(:per_page => 15, :page => params[:page]) || {}
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid shelter => #{params[:id]}")
    flash[:error] = "You have requested an invalid shelter!"
    redirect_to public_help_a_shelter_index_path
  end

end