class Public::HelpAShelterController < Public::ApplicationController
  respond_to :html, :js
  
  def index
  end
  
  def show
    @shelter = Shelter.find(params[:id])
  end
  
  def find_shelters_in_bounds
    @shelters = Shelter.find(:all, :bounds => [params[:filters][:sw],params[:filters][:ne]]).paginate(:per_page => 15, :page => params[:page])
  end

end