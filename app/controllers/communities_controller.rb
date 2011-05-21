class CommunitiesController < ApplicationController
  # caches_action :show
  # cache_sweeper :parent_sweeper
  
  respond_to :html, :js
  
  def index
    redirect_to search_by_city_zipcode_communities_path
  end
  
  def search_by_city_zipcode
  end
  
  def search_by_shelter_name
  end
  
  def animal
    @animal = Animal.includes(:animal_type, :animal_status).find(params[:animal_id])
    @notes = @animal.notes.includes(:note_category).all
    @shelter = @animal.shelter
    @transfer_requested = @animal.transfers.where(:requestor_shelter_id => @current_shelter.id).exists?
    respond_with(@animal)
  end
  
  def filter_notes
    filter_param = params[:filter]
    @animal = Animal.find(params[:animal_id])
    if filter_param.blank?
      @notes = @animal.notes
    else
      @notes = @animal.notes.animal_filter(filter_param)
    end
  end
  
  def find_animals_in_bounds
    @shelters = Shelter.find(:all, :conditions =>["shelters.id != ?", @current_shelter.id], :bounds => [params[:filters][:sw],params[:filters][:ne]])
    @animals = {}
    # @urgent_needs_animals = {}
    unless @shelters.blank?
      shelter_ids = @shelters.collect(&:id)
      @animals = Animal.community_animals(shelter_ids, params[:filters]).all.paginate(:per_page => 10, :page => params[:page])
      # @urgent_needs_animals = Animal.map_euthanasia_list(shelter_ids, params[:filters]).all.paginate(:per_page => 10, :page => params[:page])
    end
  end
  
  def find_animals_for_shelter
    @shelter = Shelter.find(params[:filters][:shelter_id])
    @capacities = @shelter.capacities
    @animals = {}
    # @urgent_needs_animals = {}
    unless @shelter.blank?
      @animals = Animal.community_animals(@shelter.id, params[:filters]).all.paginate(:per_page => 10, :page => params[:page])
      # @urgent_needs_animals = Animal.map_euthanasia_list(@shelter.id, params[:filters]).all.paginate(:per_page => 10, :page => params[:page])
    end
  end
end