class ParentsController < ApplicationController
  respond_to :html, :js, :json
  
  def index
    # No Loading because Index page is a search
  end
  
  def show
    @parent = Parent.includes(:notes).find(params[:id])

    @adopted_placements = @parent.placements.adopted.includes(:shelter, :animal => [:animal_type, :photos]).all
    @foster_care_placements = @parent.placements.foster_care.includes(:shelter, :animal => [:animal_type, :photos]).all
    respond_with(@parent)
  end
  
  def edit
    @parent = Parent.find(params[:id])
    respond_with(@parent)
  end
  
  def new
    @parent = Parent.new
    respond_with(@parent)
  end
  
  def create
    @parent = Parent.new(params[:parent])
    flash[:notice] = "#{@parent.name} has been created." if @parent.save
    respond_with(@parent)
  end
  
  def update
    @parent = Parent.find(params[:id])
    flash[:notice] = "#{@parent.name} has been updated." if @parent.update_attributes(params[:parent])      
    respond_with(@parent)
  end
  
  def destroy
    @parent = Parent.find(params[:id])
    @parent.destroy
    flash[:notice] = "#{@parent.name} has been deleted."
    respond_with(@parent)
  end
  
  def search
    q = params[:q].strip.split.join("%")
    parent_params = params[:parents].delete_if{|k,v| v.blank?} if params[:parents]
    @parents = q.blank? ? {} : Parent.search(q, parent_params).paginate(:page => params[:page]).all
  end
  
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid parent => #{params[:id]}")
    flash[:error] = "You have requested an invalid parent!"
    redirect_to parents_path and return
  end
  
end
