class DashboardController < ApplicationController
  respond_to :html, :js
  
  def index
    @transfers = @current_shelter.transfers.active
    @latest_activity = Activity.new(@current_shelter).recent(10)
  end
  
end
