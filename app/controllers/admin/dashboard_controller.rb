class Admin::DashboardController < Admin::ApplicationController
  respond_to :html, :js

  def index
    @counts_by_status = Animal.unscoped.joins(:animal_status).group("animal_statuses.name").limit(nil).count
    @counts_by_transfer_with_app = Transfer.completed.count
    @counts_by_transfer_without_app = Animal.where(:animal_status_id => AnimalStatus::STATUSES[:transferred]).count
    @active_kill_shelters_count = Shelter.active.kill_shelters.count
    @active_no_kill_shelters_count = Shelter.active.no_kill_shelters.count
    @suspended_kill_shelters_count = Shelter.suspended.kill_shelters.count
    @suspended_no_kill_shelters_count = Shelter.suspended.no_kill_shelters.count
    @cancelled_kill_shelters_count = Shelter.cancelled.kill_shelters.count
    @cancelled_no_kill_shelters_count = Shelter.cancelled.no_kill_shelters.count
    @total_active_shelters_count = Shelter.active.count
    @total_suspended_shelters_count = Shelter.suspended.count
    @total_cancelled_shelters_count = Shelter.cancelled.count
    @latest_shelters = Shelter.latest(10).all
  end
end
