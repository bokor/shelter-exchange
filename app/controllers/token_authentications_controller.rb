class TokenAuthenticationsController < ApplicationController
  respond_to :html, :js
  
  def create
    @shelter = @current_shelter
    authorize! :generate_access_token, @shelter
    @shelter.generate_access_token!
    redirect_to settings_path
  end

  def destroy
    @shelter = @current_shelter
    authorize! :generate_access_token, @shelter
    @shelter.access_token = nil
    @shelter.save
    redirect_to settings_path
  end
  
end
