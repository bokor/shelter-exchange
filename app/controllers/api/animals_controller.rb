class Api::AnimalsController < Api::ApplicationController
  respond_to :html, :json, :js
  before_filter :configure

  def index
    @animals = @current_shelter.animals.api_lookup(@types, @statuses)
    @animals = @animals.paginate(:page => params[:page], :per_page => 15).all unless request.format.json?
    respond_with(@animals)
  end

  def search
    @animals = @current_shelter.animals.api_filter(params[:filters])
    @animals = @animals.paginate(:page => params[:page], :per_page => 15).all unless request.format.json?
    respond_with(@animals)
  end

  #----------------------------------------------------------------------------
  private

  def configure
    @types =  params.has_key?(:types) ? params[:types].split(",").collect{|x| x.to_i } : []
    @statuses = params.has_key?(:statuses) ? params[:statuses].split(",").collect{|x| x.to_i } : []

    if @statuses.include?(AnimalStatus::STATUSES[:deceased]) || @statuses.include?(AnimalStatus::STATUSES[:euthanized])
      raise Errors::ApiIncorrectTypeStatus
    end
  end

  rescue_from Exception do |exception|
    respond_with_error({ :error => "Unexpected error has occurred.  Please review the API documentation to make sure everything is correct." })
  end

  rescue_from Errors::ApiIncorrectTypeStatus do |exception|
    respond_with_error({ :error => "Contains Animal Types or Statuses that are not allowed.  Please refer to the help documentation to resolve this issue." })
  end
end

