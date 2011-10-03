class Public::SaveALifeController < Public::ApplicationController
  respond_to :html, :js
  
  def index
  end
  
  def animal
    @animal = Animal.includes(:animal_type, :animal_status, :shelter).find(params[:animal_id])
    @shelter = @animal.shelter
    respond_with(@animal, @shelter) 
  end
  
  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter).find(params[:id])
    @shelter = @animal.shelter
  end
  
  def find_animals_in_bounds
    @shelters = Shelter.find(:all, :bounds => [params[:filters][:sw],params[:filters][:ne]])
    unless @shelters.blank?
      shelter_ids = @shelters.collect(&:id)
      @animals = Animal.community_animals(shelter_ids, params[:filters]).available_for_adoption.all.paginate(:per_page => 10, :page => params[:page]) || {}
    end
  end
  
  def find_animals_for_shelter
    @shelter = Shelter.find(params[:filters][:shelter_id])
    @capacities = @shelter.capacities
    unless @shelter.blank?
      @animals = Animal.community_animals(@shelter.id, params[:filters]).available_for_adoption.all.paginate(:per_page => 10, :page => params[:page]) || {}
    end
  end
  
end