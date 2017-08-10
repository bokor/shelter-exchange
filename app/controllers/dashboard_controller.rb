class DashboardController < ApplicationController
  respond_to :html, :js

  def index
    @latest_activity = Activity.recent(@current_shelter)
  end
end

