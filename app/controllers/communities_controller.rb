class CommunitiesController < ApplicationController
  respond_to :html, :js

  def index
  end

  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter, :photos, :transfers).find(params[:id])
    @shelter = @animal.shelter
    raise ShelterExchange::Errors::ShelterInactive if @shelter.inactive?
    @photos = @animal.photos
    @gallery_photos = PhotoPresenter.as_gallery_collection(@photos)

    @notes = @animal.notes.includes(:documents).all
    @transfer_requested = @animal.transfers.where(:requestor_shelter_id => @current_shelter.id).exists?
  end

  def filter_notes
    filter_param = params[:filter]
    @animal = Animal.find(params[:animal_id])
    if filter_param.blank?
      @notes = @animal.notes.includes(:documents).all
    else
      @notes = @animal.notes.includes(:documents).where(:category => filter_param).all
    end
  end

  def find_animals_in_bounds
    map_center     = params[:filters][:map_center].split(',')
    distance       = params[:filters][:distance].to_f
    sw_lat, sw_lng = params[:filters][:sw].split(',')
    ne_lat, ne_lng = params[:filters][:ne].split(',')

    shelter_ids = Shelter.
      near(map_center, distance, :select => "id").
      within_bounding_box([sw_lat, sw_lng, ne_lat, ne_lng]).active.collect(&:id)

    # Remove the current shelter from the list so they don't see their animals
    shelter_ids.delete(@current_shelter.id)

    @animals = Animal.
      community_animals(shelter_ids, params[:filters]).
      paginate(:page => params[:page], :per_page => 10).all || {}
  end

  def find_animals_for_shelter
    @shelter = Shelter.active.find(params[:filters][:shelter_id])
    unless @shelter.blank?
      @capacities = @shelter.capacities.includes(:animal_type).all
      @animals = Animal.
        community_animals(@shelter.id, params[:filters]).
        paginate(:page => params[:page], :per_page => 10).all || {}
    end
  end

  rescue_from ActiveRecord::RecordNotFound, ShelterExchange::Errors::ShelterInactive do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an animal that is no longer listed!"
    redirect_to communities_path
  end
end

