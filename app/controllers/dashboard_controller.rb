class DashboardController < ApplicationController
  respond_to :html, :js
  
  def index
    @transfers = @current_shelter.transfers.includes(:comments).not_completed
    @animals = @current_shelter.animals.latest(5).all.paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
  end
  
end