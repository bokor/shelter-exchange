class SettingsController < ApplicationController
  before_filter :authorize_settings!
  respond_to :html, :js
  
  def index
    @tab = params[:tab]
    send(@tab) unless @tab.blank?
  end
  
  
  private
  
    def authorize_settings!
      authorize!(:view_settings, User)
    end
    
    # Tab Actions
    #----------------------------------------------------------------------------
    def change_owner
      @users = @current_account.users.all
      @owner = @current_account.users.owner.first
    end

    def web_access
    end
    
    def exports
    end

    def connect
      @adopt_a_pet = Integration::AdoptAPet.where(:shelter_id => @current_shelter).first || 
                     Integration::AdoptAPet.new(:shelter => @current_shelter)

      @petfinder   = Integration::Petfinder.where(:shelter_id => @current_shelter).first || 
                     Integration::Petfinder.new(:shelter => @current_shelter)
    end
    
  
end
