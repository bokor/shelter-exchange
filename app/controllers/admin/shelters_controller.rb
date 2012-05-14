class Admin::SheltersController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @kill_shelters = Shelter.kill_shelters.paginate(:page => params[:kill_shelters_page])
    @no_kill_shelters = Shelter.no_kill_shelters.paginate(:page => params[:no_kill_shelters_page])
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    @account = @shelter.account
    @capacities = @shelter.capacities.includes(:animal_type).all
    @users = @shelter.account.users.all
    @counts_by_status = Animal.unscoped.joins(:animal_status).where(:shelter_id => @shelter).group("animal_statuses.name").limit(nil).count
    respond_with(@shelter)
  end
  
  def edit
    @shelter = Shelter.find(params[:id])
    @account = @shelter.account
  end
  
  def update
    @shelter = Shelter.find(params[:id])
    @account = @shelter.account
    flash[:notice] = "#{@shelter.name} is now #{@shelter.status.humanize}." if @shelter.update_attributes(params[:shelter])
  end
  
  def live_search
    q = params[:q].strip 
    shelter_params = params[:shelters].delete_if{|k,v| v.blank?} if params[:shelters]
    @kill_shelters    = Shelter.live_search(q, shelter_params).kill_shelters.paginate(:page => params[:kill_shelters_page])
    @no_kill_shelters = Shelter.live_search(q, shelter_params).no_kill_shelters.paginate(:page => params[:no_kill_shelters_page])
  end
  
end