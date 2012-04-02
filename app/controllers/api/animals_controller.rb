class Api::AnimalsController < Api::ApplicationController
  respond_to :html, :json, :xml
  
  before_filter :configure

    
  def index
    unless request.format.html?
      @animals = @current_shelter.animals.api_lookup(@types, @statuses).all
    else
      @animals = @current_shelter.animals.api_lookup(@types, @statuses).paginate(:per_page => Animal::PER_PAGE_API, :page => params[:page])
    end
  end
    
  rescue_from Exception do |exception|
    respond_with_error({ :error => "Unexpected error has occurred.  Please review the API documentation to make sure everything is correct." })
  end
  
  rescue_from Exceptions::ApiIncorrectStatus do |exception|
    respond_with_error({ :error => "Contains Animal Statuses that are not allowed.  Please refer to the help documentation to resolve." })
  end
  
  private
   
    def configure
      @types =  params.has_key?(:types) ? params[:types].split(",").collect{|x| x.to_i } : []
      @statuses = params.has_key?(:statuses) ? params[:statuses].split(",").collect{|x| x.to_i } : []

      # Throws exception for Deceased and Euthanized Statuses.
      raise Exceptions::ApiIncorrectStatus if @statuses.include?(AnimalStatus::STATUSES[:deceased]) or @statuses.include?(AnimalStatus::STATUSES[:euthanized])
    end
  
end