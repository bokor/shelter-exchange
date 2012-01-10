class SettingsController < ApplicationController
  before_filter :authorize_settings!, :set_tab_action
  respond_to :html, :js
  
  def index
  end
  
  def change_owner
    @users = @current_account.users.all
    @owner = @current_account.users.owner.first
    render :index
  end
  
  def web_access
    render :index
  end
  
  def connect
    render :index
  end
  
  private
  
    def authorize_settings!
      authorize!(:view_settings, User)
    end
    
    def set_tab_action
      @tab = action_name=="index" ? nil : "#{action_name}"
    end
  
end
