class Api::ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :shelter_lookup, :shelter_inactive?
  layout :current_layout
  

  private

    def current_layout
      (request.format.html? or request.format.js?) ? 'api/application' : false
    end  
  
    def access_token
      @access_token ||= params[:access_token]
    end

    def shelter_lookup
      @current_shelter = Shelter.by_access_token(access_token).first || respond_with_error({ :error => "Not Authorized to perform this action" })
    end 
    
    def shelter_inactive?
      respond_with_error({ :error => "#{@current_shelter.name}'s access has been #{@current_shelter.status}" })  if @current_shelter.inactive?
    end

    def respond_with_error(msg)
      @error = msg[:error]
      respond_to do |format|
        format.html { render :html, :template => "api/error" }
        format.json { render :json => msg.to_json, :status => :forbidden }
        format.xml { render :xml => msg.to_xml, :status => :forbidden }
      end
    end

end