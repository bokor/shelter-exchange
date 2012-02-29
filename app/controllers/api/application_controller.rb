class Api::ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_access_token, :shelter_lookup, :shelter_suspended?
  layout :current_layout
  

  private
  
    def set_access_token
      @access_token ||= params[:access_token]
    end
      
    def current_layout
      (request.format.html? or request.format.js?) ? 'api/application' : false
    end

    def shelter_lookup
      @current_shelter = Shelter.by_access_token(params[:access_token]).first
      respond_with_error({ :error => "Not Authorized to perform this action" })  if @current_shelter.blank?
    end 
    
    def shelter_suspended?
      respond_with_error({ :error => "#{@current_shelter.name}'s access has been suspended" })  if @current_shelter.suspended?
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