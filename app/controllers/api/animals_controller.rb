class Api::AnimalsController < Api::ApplicationController
  respond_to :html, :json, :xml
    
  def index
    types = params[:types].split(",").collect{|x| x.to_i } 
    statuses = params[:statuses].split(",").collect{|x| x.to_i }
    
    unless request.format.html?
      @animals = @current_shelter.animals.api_lookup(types, statuses)
    else
      @animals = @current_shelter.animals.api_lookup(types, statuses).paginate(:per_page => Animal::PER_PAGE_API, :page => params[:page])
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
  
end