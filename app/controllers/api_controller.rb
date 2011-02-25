class ApiController < ApplicationController
  # load_and_authorize_resource
  skip_before_filter :authenticate_user!, :current_shelter, :set_shelter_timezone, :store_location, :set_mailer_url_options
  before_filter :api_version, :find_shelter
  
  respond_to :json, :xml
  
  def animals
    case @version
      when :v1
        @animals = @shelter.animals.includes(:animal_type, :animal_status)
        respond_with(@animals) do |format|  
          format.json {
            render :json => @animals.to_json(:except =>[:id,:animal_type_id, :animal_status_id, :accommodation_id, :shelter_id, :created_at, :updated_at, :status_change_date, :photo_content_type, :photo_file_name, :photo_file_size, :photo_updated_at],
                                                         :include => { :animal_type => {:only => [:name]}, :animal_status => {:only => [:name]} }), #, :photo => {:methods => [:photo_url]}
                                                         :callback => params[:callback] 
          #   render :json => @animals.collect{ |animal| { 
          #     :name => animal.name,
          #     :type => animal.animal_type.name,
          #     :photo => animal.photo.url(:original) } }
          }
          format.xml {render :xml => @animals.to_xml()}
        end
        
      # when :v2
      #         @animals = @current_shelter.animals.includes(:animal_type, :animal_status)
      #         respond_with(@animals) do |format|
      #           format.json {render :json => @animals.to_json}
      #           format.xml {render :xml => @animals.to_xml}
      #         end
    end
  end
  
  def api_version
    @version = params[:version].to_sym
  end
  
  def find_shelter
    @shelter = @current_account.shelters.by_access_token(params[:access_token]).first
    # if @shelter.blank?
    #       respond_to do |format|
    #         format.html
    #         format.json { render :json => {}, :status => :error }
    #       end
    #     end
  end
  
end