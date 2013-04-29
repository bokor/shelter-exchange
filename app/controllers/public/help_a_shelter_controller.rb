class Public::HelpAShelterController < Public::ApplicationController
  respond_to :html, :js

  # caches_action :index
  # caches_action :show, :expires_in => 2.minutes

  def index
  end

  def show
    @shelter = Shelter.active.find(params[:id])
    @items = @shelter.items.select(:name).all
  end

  def search_by_shelter_or_rescue_group
    q = params[:q]
    unless q.blank?
      q.strip.split.join("%")
      shelter_params = params[:shelters].delete_if{|k,v| v.blank?} if params[:shelters]
      @shelters = q.blank? ? {} : Shelter.search_by_name(q, shelter_params).active.paginate(:page => params[:page], :per_page => 15).all
    end
  end

  def find_shelters_in_bounds
    map_center     = params[:filters][:map_center].split(',')
    distance       = params[:filters][:distance].to_f
    sw_lat, sw_lng = params[:filters][:sw].split(',')
    ne_lat, ne_lng = params[:filters][:ne].split(',')

    @shelters = Shelter.
      near(map_center, distance).
      within_bounding_box([sw_lat, sw_lng, ne_lat, ne_lng]).
      active.
      paginate(:page => params[:page], :per_page => 15).all
  end

  def find_animals_for_shelter
    shelter_id = params[:filters][:shelter_id]
    @animals = Animal.
      community_animals(shelter_id, params[:filters]).
      available.
      paginate(:page => params[:page], :per_page => 15).all || {}
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid shelter => #{params[:id]}")
    flash[:error] = "You have requested a shelter that is no longer listed!"
    self.action_name = "index"
    render :action => :index, :status => 404
  end
end

