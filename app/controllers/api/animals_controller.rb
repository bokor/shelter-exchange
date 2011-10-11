class Api::AnimalsController < Api::ApplicationController
  respond_to :html, :json, :xml
    
  def index
    types =  params.has_key?(:types) ? params[:types].split(",").collect{|x| x.to_i } : []
    statuses = params.has_key?(:statuses) ? params[:statuses].split(",").collect{|x| x.to_i } : []
    
    unless request.format.html?
      @animals = Animal.api_lookup(types, statuses, @current_shelter)
    else
      @animals = Animal.api_lookup(types, statuses, @current_shelter).paginate(:per_page => Animal::PER_PAGE_API, :page => params[:page])
    end
      
    respond_with(@animals)

  end
  
  def show
    unless request.format.html?
      respond_with_error({ :error => "URL is incorrect format.  Only HTML type works for this link" })
    else
      @animal = @current_shelter.animals.includes(:animal_type, :animal_status).find(params[:id])
      respond_with(@animal)
    end
  end
  
  rescue_from Exception do |exception|
    respond_with_error({ :error => "Unexpected error has occurred.  Please review the API documentation to make sure everything is correct." })
  end
  
end