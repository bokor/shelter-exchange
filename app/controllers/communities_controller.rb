class CommunitiesController < ApplicationController
  respond_to :html, :js
  
  def index
  end
  
  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter).find(params[:id])
    @notes = @animal.notes.all
    @shelter = @animal.shelter
    @transfer_requested = @animal.transfers.where(:requestor_shelter_id => @current_shelter.id)
  end
  
  def filter_notes
    filter_param = params[:filter]
    @animal = Animal.find(params[:animal_id])
    if filter_param.blank?
      @notes = @animal.notes
    else
      @notes = @animal.notes.where(:category => filter_param)
    end
  end
  
  def find_animals_in_bounds
    @shelters = Shelter.find(:all, :conditions =>["shelters.id != ?", @current_shelter.id], :bounds => [params[:filters][:sw],params[:filters][:ne]])
    unless @shelters.blank?
      shelter_ids = @shelters.collect(&:id)
      @animals = Animal.community_animals(shelter_ids, params[:filters]).all.paginate(:per_page => 10, :page => params[:page]) || {}
    end
  end
  
  def find_animals_for_shelter
    @shelter = Shelter.find(params[:filters][:shelter_id])
    @capacities = @shelter.capacities
    unless @shelter.blank?
      @animals = Animal.community_animals(@shelter.id, params[:filters]).all.paginate(:per_page => 10, :page => params[:page]) || {}
    end
  end
  
end