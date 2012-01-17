class Admin::SheltersController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @kill_shelters = Shelter.kill_shelters.paginate(:per_page => 25, :page => params[:kill_shelters_page])
    @no_kill_shelters = Shelter.no_kill_shelters.paginate(:per_page => 25, :page => params[:no_kill_shelters_page])
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    @account = @shelter.account
    @capacities = @shelter.capacities.includes(:animal_type).all
    @users = @shelter.account.users
    @counts_by_status = Animal.unscoped.joins(:animal_status).where(:shelter_id => @shelter).group("animal_statuses.name").limit(nil).count
    respond_with(@shelter)
  end
  
  def live_search
    q = params[:q].strip
    @kill_shelters = q.blank? ? Shelter.kill_shelters.paginate(:per_page => 25, :page => params[:kill_shelters_page]) : Shelter.live_search(q).kill_shelters.paginate(:per_page => 25, :page => params[:kill_shelters_page])
    @no_kill_shelters = q.blank? ? Shelter.no_kill_shelters.paginate(:per_page => 25, :page => params[:no_kill_shelters_page]) : Shelter.live_search(q).no_kill_shelters.paginate(:per_page => 25, :page => params[:no_kill_shelters_page])
  end
  
end