class ApiController < ApplicationController
  skip_before_filter :authenticate_user!, :current_shelter, :set_shelter_timezone
  before_filter :api_version, :find_shelter
  
  layout :api_layout
  
  respond_to :html, :js, :json, :xml
    
  def animals
    animal_view_path = "api/#{api_version}/animals"
    
    if API_VERSION.include?(api_version)
      unless request.format.html? or request.format.js?
        @animals = @shelter.animals.includes(:animal_type, :animal_status).available_for_adoption
      else
        @animals = @shelter.animals.includes(:animal_type, :animal_status).available_for_adoption.paginate(:per_page => 2, :page => params[:page])
      end
      respond_with(@animals) do |format|  
        format.html { render :html, :template => animal_view_path }
        format.js { render :js, :template => animal_view_path }
        format.json { render :json, :template => animal_view_path }
        format.xml { render :xml, :template => animal_view_path }
      end
    else
      respond_with_error({ :error => "Incorrect version" })
    end
  end
  
  
  
  private
  
    def api_layout
      request.format.html? or request.format.js? ? 'api' : false
    end
  
    def account_blocked?
      respond_with_error({ :error => "Account's access has been revoked.  Reason: #{@current_account.reason_blocked}" })  if @current_account.blocked?
    end
  
    def api_version
      @api_version ||= params[:version]
    end
  
    def find_shelter
      @shelter = @current_account.shelters.by_access_token(params[:access_token]).first
      respond_with_error({ :error => "Not Authorized to perform this action" })  if @shelter.blank?
    end 
    
    def respond_with_error(error)
      respond_to do |format|
        format.html { render :html, :template => "api/error" }
        format.json { render :json => error.to_json, :status => :forbidden }
        format.xml { render :xml => error.to_xml, :status => :forbidden }
      end
    end
  
end