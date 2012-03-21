class CommunitiesController < ApplicationController
  respond_to :html, :js
  
  def index
  end
  
  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter).find(params[:id])
    @shelter = @animal.shelter
    raise Exceptions::ShelterInactive if @shelter.inactive?
    @notes = @animal.notes.all
    @transfer_requested = @animal.transfers.where(:requestor_shelter_id => @current_shelter.id).exists?
  end
  
  def filter_notes
    filter_param = params[:filter]
    @animal = Animal.find(params[:animal_id])
    if filter_param.blank?
      @notes = @animal.notes.all
    else
      @notes = @animal.notes.where(:category => filter_param).all
    end
  end
  
  def find_animals_in_bounds
    shelter_ids = Shelter.find(:all, :select => :id, :conditions => ["shelters.status = ? and shelters.id != ?", "active", @current_shelter.id], :bounds => [params[:filters][:sw],params[:filters][:ne]])
    unless shelter_ids.blank?
      @animals = Animal.community_animals(shelter_ids, params[:filters]).paginate(:per_page => 10, :page => params[:page]) || {}
    end
  end
  
  def find_animals_for_shelter
    @shelter = Shelter.active.find(params[:filters][:shelter_id])
    unless @shelter.blank?
      @capacities = @shelter.capacities.includes(:animal_type).all
      @animals = Animal.community_animals(@shelter.id, params[:filters]).paginate(:per_page => 10, :page => params[:page]) || {}
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound, Exceptions::ShelterInactive do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an animal that is no longer listed!"
    redirect_to communities_path
  end
  
  
end