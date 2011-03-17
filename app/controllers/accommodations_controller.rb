class AccommodationsController < ApplicationController
  # caches_action :index
  # cache_sweeper :accommodation_sweeper
  
  respond_to :html, :js
  
  def index
    @accommodations = @current_shelter.accommodations.includes(:location, :animal_type, :animals => [:animal_status]).paginate(:per_page => Accommodation::PER_PAGE, :page => params[:page])
  
    if @accommodations.blank?
      redirect_to new_task_path
    end  
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
        format.html { render :action => :index }
      end
    end
  end
  
  def update
    @accommodation = @current_shelter.accommodations.find(params[:id])   
    flash[:notice] = "#{@accommodation.name} accommodation has been updated." if @accommodation.update_attributes(params[:accommodation])  
    respond_with(@accommodation)
  end
  
  def destroy
    @accommodation = @current_shelter.accommodations.find(params[:id])
    @accommodation.destroy
    flash[:notice] = "#{@accommodation.name} accommodation has been deleted."
    respond_with(@accommodation)
  end
  
  def search
    q = params[:q].strip
    @accommodations = q.blank? ? {} : @current_shelter.accommodations.search(q).paginate(:per_page => Accommodation::PER_PAGE, :page => params[:page])
  end
  
  def filter_by_type_location
    type = params[:animal_type_id]
    location = params[:location_id]
    if type.empty? and location.empty?
      @accommodations = @current_shelter.accommodations.includes(:animal_type, :animals, :location).paginate(:per_page => Accommodation::PER_PAGE, :page => params[:page])
    elsif is_integer?(type) and location.empty?
      @accommodations = @current_shelter.accommodations.includes(:animal_type, :animals, :location).where(:animal_type_id => type).paginate(:per_page => Accommodation::PER_PAGE, :page => params[:page])
    elsif type.empty? and is_integer?(location)
      @accommodations = @current_shelter.accommodations.includes(:animal_type, :animals, :location).where(:location_id => location).paginate(:per_page => Accommodation::PER_PAGE, :page => params[:page])
    elsif is_integer?(type) and is_integer?(location)
      @accommodations = @current_shelter.accommodations.includes(:animal_type, :animals, :location).where(:animal_type_id => type, :location_id => location).paginate(:per_page => Accommodation::PER_PAGE, :page => params[:page])
    end
  end

end