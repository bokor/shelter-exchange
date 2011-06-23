class Admin::SheltersController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @kill_shelters = Shelter.where(:is_kill_shelter => true).all
    @no_kill_shelters = Shelter.where(:is_kill_shelter => false).all
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    respond_with(@shelter)
  end
  
end