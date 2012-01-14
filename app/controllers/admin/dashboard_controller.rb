class Admin::DashboardController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @counts_by_status = Animal.unscoped.joins(:animal_status).group("animal_statuses.name").limit(nil).count
    @counts_by_transfer = Transfer.where(:status => Transfer::COMPLETED).count
    @kill_shelters_count = Shelter.kill_shelters.count
    @no_kill_shelters_count = Shelter.no_kill_shelters.count
    @all_shelters_count = Shelter.count
    @latest_shelters = Shelter.latest(10)
    @latest_adoptions = Animal.latest_adoptions(10)
  end
  
end
