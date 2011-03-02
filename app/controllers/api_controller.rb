class ApiController < ApplicationController
  # load_and_authorize_resource
  skip_before_filter :authenticate_user!, :current_shelter, :set_shelter_timezone
  before_filter :find_shelter
  
  respond_to :json, :xml
  
  def animals
    if API_VERSION.include?(api_version)
      @animals = @shelter.animals.includes(:animal_type, :animal_status).available_for_adoption
      options = { :version => api_version.to_sym }
      respond_with(@animals) do |format|  
        format.json { render :json => @animals.to_json(options), :callback => params[:callback] }
        format.xml { render :xml => @animals.to_xml(options), :callback => params[:callback] }
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
      params[:version]
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

# options = {:except =>[:animal_type_id, :animal_status_id, :accommodation_id, :shelter_id, :created_at, :updated_at, :status_change_date, :photo_content_type, :photo_file_size, :photo_file_name, :photo_updated_at, :primary_breed, :secondary_breed, :is_mix_breed, :chip_id,:arrival_date, :euthanasia_scheduled, :hold_time],
#            :include => { :animal_type => {:only => [:name]}, :animal_status => {:only => [:name]} },
#            :methods => [:photo_url, :full_breed],
#            :dasherize => false, :skip_types => true}

