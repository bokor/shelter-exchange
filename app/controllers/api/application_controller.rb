class Api::ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_access_token, :shelter_lookup, :account_blocked?

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
    
    def account_blocked?
      @current_account = @current_shelter.account
      respond_with_error({ :error => "Account's access has been revoked.  Reason: #{@current_account.reason_blocked}" })  if @current_account.blocked?
    end

    def respond_with_error(error)
      respond_to do |format|
        format.html { render :html, :template => "api/error" }
        format.json { render :json => error.to_json, :status => :forbidden }
        format.xml { render :xml => error.to_xml, :status => :forbidden }
      end
    end


end