class SettingsController < ApplicationController
  before_filter :authorize_settings!
  respond_to :html, :js
  
  def index
    @users = @current_account.users.all
    @owner = @current_account.users.owner.first
  end
  
  def authorize_settings!
    authorize!(:view_settings, User)
  end
  
end
