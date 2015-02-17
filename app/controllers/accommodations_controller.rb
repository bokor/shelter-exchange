class AccommodationsController < ApplicationController
  respond_to :html, :js

  def index
    query = params[:query]
    type_id = params[:animal_type_id]
    location_id = params[:location_id]
    order_by = params[:order_by]

    @accommodations = @current_shelter.accommodations.search_and_filter(query, type_id, location_id, order_by)
    @accommodations = @accommodations.paginate(:page => params[:page]).all

    redirect_to new_accommodation_path and return if request.format.html? && @accommodations.blank?
    respond_with(@accommodations)
  end

  def edit
    @accommodation = @current_shelter.accommodations.find(params[:id])
    respond_with(@accommodation)
  end

  def new
    @accommodation = @current_shelter.accommodations.new
    respond_with(@accommodation)
  end

  def create
    @accommodation = @current_shelter.accommodations.new(params[:accommodation])

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
    @accommodation = @current_shelter.accommodations.find(params[:id])

    if @accommodation.update_attributes(params[:accommodation])
      flash[:notice] = "#{@accommodation.name} accommodation has been updated."
    end

    respond_with(@accommodation)
  end

  def destroy
    @accommodation = @current_shelter.accommodations.find(params[:id])
    flash[:notice] = "#{@accommodation.name} accommodation has been deleted." if @accommodation.destroy
    respond_with(@accommodation)
  end
end

