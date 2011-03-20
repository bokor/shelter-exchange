class ApiController < ApplicationController
  skip_before_filter :authenticate_user!, :current_shelter, :set_shelter_timezone
  before_filter :find_shelter
  
  respond_to :json, :xml
  
  def animals
    if API_VERSION.include?(api_version)
      @animals = @shelter.animals.includes(:animal_type, :animal_status).active
      respond_with(@animals) do |format|  
        format.json { render "api/#{api_version}/animals.json" }
        format.xml { render "api/#{api_version}/animals.xml" }
      end
    else
      error = { :error => "Incorrect version" }
      respond_to do |format|
        format.json { render :json => error.to_json, :callback => params[:callback] }
        format.xml { render :xml => error.to_xml, :callback => params[:callback] }
      end
    end
  end
  
  private
    def api_version
      @api_version ||= params[:version]
    end
  
    def find_shelter
      @shelter = @current_account.shelters.by_access_token(params[:access_token]).first
      if @shelter.blank?
        error = { :error => "Not Authorized to perform this action" }
        respond_to do |format|
          format.json { render :json => error.to_json, :status => :forbidden }
          format.xml { render :xml => error.to_xml, :status => :forbidden }
        end
      end
    end
  
end