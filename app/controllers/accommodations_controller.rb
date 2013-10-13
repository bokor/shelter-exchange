class AccommodationsController < ApplicationController
  respond_to :html, :js

  def index
    @accommodations = current_shelter.accommodations.
      includes(:location, :animal_type, :animals => [:animal_status, :photos]).
      paginate(:page => params[:page])

    redirect_to new_accommodation_path if @accommodations.blank?
  end

  def edit
    @accommodation = current_shelter.accommodations.find(params[:id])
    respond_with(@accommodation)
  end

  def new
    @accommodation = current_shelter.accommodations.new
    respond_with(@accommodation)
  end

  def create
    @accommodation = current_shelter.accommodations.new(params[:accommodation])

    respond_with(@accommodation) do |format|
      if @accommodation.save
        flash[:notice] = "#{@accommodation.name} accommodation has been created."
        format.html { redirect_to accommodations_path }
      else
        format.html { render :action => :new }
      end
    end
  end

  def update
    @accommodation = current_shelter.accommodations.find(params[:id])

    if @accommodation.update_attributes(params[:accommodation])
      flash[:notice] = "#{@accommodation.name} accommodation has been updated."
    end

    respond_with(@accommodation)
  end

  def destroy
    @accommodation = current_shelter.accommodations.find(params[:id])
    @accommodation.destroy
    flash[:notice] = "#{@accommodation.name} accommodation has been deleted."
    respond_with(@accommodation)
  end

  def search
    query = params[:q] ? params[:q].strip : ""
    @accommodations = {}

    unless query.blank?
      @accommodations = @current_shelter.accommodations.search(query).paginate(:page => params[:page])
    end
  end

  def filter_by_type_location
    @accommodations = @current_shelter.accommodations.filter_by_type_location(params[:animal_type_id], params[:location_id]).paginate(:page => params[:page])
  end
end

