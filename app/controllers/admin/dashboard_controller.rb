class Admin::DashboardController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @counts_by_status = Animal.unscoped.joins(:animal_status).group("animal_statuses.name").limit(nil).count
    @counts_by_transfer = Transfer.where(:status => Transfer::COMPLETED).count
  end
  
end
