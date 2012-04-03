class Api::AnimalsController < Api::ApplicationController
  respond_to :html, :json
  before_filter :configure, :api_version
    
  def index
    unless request.format.html?
      @animals = @current_shelter.animals.api_lookup(@types, @statuses).all
      @animal_presenter = "Api::#{api_version.upcase}::AnimalPresenter".constantize.as_collection(@animals)
    else
      @animals = @current_shelter.animals.api_lookup(@types, @statuses).paginate(:per_page => Animal::PER_PAGE_API, :page => params[:page])
    end
    
    respond_to do |format|
      format.html
      format.json{ render :json => @animal_presenter.to_json, :callback => params[:callback] }
    end
  end
  
  
  def show
    @animal = @current_shelter.animals.find(params[:id])
    @animal_presenter = "Api::#{api_version.upcase}::AnimalPresenter".constantize.new(@animal)
    
    respond_to do |format|
      format.json{ render :json => @animal_presenter.to_json, :callback => params[:callback] }
    end
  end
  
  
  
    
  private
   
    def configure
      @types =  params.has_key?(:types) ? params[:types].split(",").collect{|x| x.to_i } : []
      @statuses = params.has_key?(:statuses) ? params[:statuses].split(",").collect{|x| x.to_i } : []

      raise Exceptions::ApiIncorrectTypeStatus if @statuses.include?(AnimalStatus::STATUSES[:deceased]) or @statuses.include?(AnimalStatus::STATUSES[:euthanized])
    end
    
    def api_version
      params[:version] || CURRENT_API_VERSION
    end
    
    rescue_from Exception do |exception|
      respond_with_error({ :error => "Unexpected error has occurred.  Please review the API documentation to make sure everything is correct." })
    end

    rescue_from NameError do |exception|
      respond_with_error({ :error => "Incorrect API Version.  Please review the API documentation to make sure everything is correct." })
    end

    rescue_from Exceptions::ApiIncorrectTypeStatus do |exception|
      respond_with_error({ :error => "Contains Animal Types or Statuses that are not allowed.  Please refer to the help documentation to resolve this issue." })
    end
  
end