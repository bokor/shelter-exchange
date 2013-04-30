class Public::SaveALifeController < Public::ApplicationController
  respond_to :html, :js

  # caches_action :index
  # caches_action :show, :cache_path => Proc.new {|c| "save_a_life/#{c.params[:id]}" }

  def index
  end

  def show
    @animal = Animal.includes(:animal_type, :animal_status, :shelter, :photos).find(params[:id])
    @shelter = @animal.shelter
    raise ActiveRecord::RecordNotFound if @shelter.inactive?
    @photos = @animal.photos
    @gallery_photos = PhotoPresenter.as_gallery_collection(@photos)
  end

  def find_animals_in_bounds
    map_center     = params[:filters][:map_center].split(',')
    distance       = params[:filters][:distance].to_f
    sw_lat, sw_lng = params[:filters][:sw].split(',')
    ne_lat, ne_lng = params[:filters][:ne].split(',')

    shelter_ids = Shelter.
      near(map_center, distance, :select => "id").
      within_bounding_box([sw_lat, sw_lng, ne_lat, ne_lng]).active.collect(&:id)

    @animals = if shelter_ids.any?
      Animal.
        community_animals(shelter_ids, params[:filters]).
        available.
        paginate(:page => params[:page], :per_page => 10).all
    else
      {}
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid animal => #{params[:id]}")
    flash[:error] = "You have requested an animal that is no longer listed!"
    self.action_name = "index"
    render :action => :index, :status => 404
  end
end

