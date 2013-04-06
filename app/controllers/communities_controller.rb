class CommunitiesController < ApplicationController
  respond_to :html, :js

  def index
  end

  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter, :photos).find(params[:id])
    @shelter = @animal.shelter
    raise ShelterExchange::Errors::ShelterInactive if @shelter.inactive?
    @photos = @animal.photos
    @gallery_photos = PhotoPresenter.new(@photos).to_gallery

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
    shelter_ids = Shelter.active.within_bounds(params[:filters][:sw].split(','), params[:filters][:ne].split(',')).collect(&:id)
    # Remove the current shelter from the list so they don't see their animals
    shelter_ids.delete(@current_shelter.id)
    @animals = Animal.community_animals(shelter_ids, params[:filters]).paginate(:page => params[:page], :per_page => 10).all || {}
  end

  def find_animals_for_shelter
    @shelter = Shelter.active.find(params[:filters][:shelter_id])
    unless @shelter.blank?
      @capacities = @shelter.capacities.includes(:animal_type).all
      @animals = Animal.community_animals(@shelter.id, params[:filters]).paginate(:page => params[:page], :per_page => 10).all || {}
    end
  end

  rescue_from ActiveRecord::RecordNotFound, ShelterExchange::Errors::ShelterInactive do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an animal that is no longer listed!"
    redirect_to communities_path
  end


end
