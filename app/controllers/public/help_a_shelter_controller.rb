class Public::HelpAShelterController < Public::ApplicationController
  respond_to :html, :js
  
  def index
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    @items = @shelter.items.select(:name)
    @types = AnimalType.available_for_adoption_types(@shelter.id)
  end
  
  def find_shelters_in_bounds
    @shelters = Shelter.find(:all, :bounds => [params[:filters][:sw],params[:filters][:ne]]).paginate(:per_page => 15, :page => params[:page])
  end
  
  def animals_by_type
    # filter_param = params[:filter]
    # @animal = @current_shelter.animals.find(params[:id])
    # if filter_param.blank?
    #   @notes = @animal.notes
    # else
    #   @notes = @animal.notes.where(:category => filter_param)
    # end
  end

end