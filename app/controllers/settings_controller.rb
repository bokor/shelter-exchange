class SettingsController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js
  
  def index
    @users = @current_account.users.all
    @owner = @current_account.users.owner.first
  end
  
end
