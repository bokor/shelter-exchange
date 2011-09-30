class Admin::SheltersController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @kill_shelter_total = Shelter.kill_shelters.all.count
    @no_kill_shelter_total = Shelter.no_kill_shelters.all.count
    @kill_shelters = Shelter.kill_shelters.all
    @no_kill_shelters = Shelter.no_kill_shelters.all
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    @account = @shelter.account
    @capacities = @shelter.capacities
    @users = @shelter.account.users
    @counts_by_status = Animal.unscoped.joins(:animal_status).where(:shelter_id => @shelter).group("animal_statuses.name").limit(nil).count
    respond_with(@shelter)
  end
  
  def live_search
    q = params[:q].strip
    @kill_shelters = q.blank? ? Shelter.kill_shelters.all : Shelter.live_search(q).kill_shelters.all
    @no_kill_shelters = q.blank? ? Shelter.no_kill_shelters.all : Shelter.live_search(q).no_kill_shelters.all
  end
  
end