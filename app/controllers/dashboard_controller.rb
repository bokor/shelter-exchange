class DashboardController < ApplicationController
  respond_to :html, :js

  def index
    @transfers = @current_shelter.transfers.includes(:shelter, :requestor_shelter, :animal).active.all
    @latest_activity = Activity.recent(@current_shelter)
  end
end

