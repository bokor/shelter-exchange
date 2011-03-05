class LogosController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js
  
  def destroy
    @shelter = @current_shelter
    @shelter.logo.clear 
    @shelter.save
  end
  

end
