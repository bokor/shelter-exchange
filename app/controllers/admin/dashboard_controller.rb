class Admin::DashboardController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @transfers = Animal.unscoped.joins(:animal_status).group("animal_statuses.name").limit(nil).count
    # @transfers = Animal.joins(:animal_status).merge(AnimalStatus.active).all
                        
  end
  
end
