class Admin::SheltersController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @kill_shelters = Shelter.where(:is_kill_shelter => true).order('name ASC').all
    @no_kill_shelters = Shelter.where(:is_kill_shelter => false).order('name ASC').all
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    @account = @shelter.account
    @capacities = @shelter.capacities
    @users = @shelter.account.users
    @counts_by_status = @shelter.animals.unscoped.joins(:animal_status).group("animal_statuses.name").limit(nil).count
    respond_with(@shelter)
  end
  
end