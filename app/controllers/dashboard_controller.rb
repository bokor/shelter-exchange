class DashboardController < ApplicationController
  respond_to :html, :js
  
  def index
    @transfers = Transfer.includes(:comments).where(:from_shelter_id => @current_shelter.id, :status => nil)
    @animals = @current_shelter.animals.latest(5).all.paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
  end
  
end