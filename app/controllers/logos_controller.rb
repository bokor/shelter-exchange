class LogosController < ApplicationController
  respond_to :html, :js
  
  def destroy
    @shelter = @current_shelter
    @shelter.logo.clear 
    @shelter.save
  end
  

end
