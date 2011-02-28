class ParentsController < ApplicationController
  # load_and_authorize_resource
  # caches_action :show
  # cache_sweeper :parent_sweeper
  
  respond_to :html, :js
  
  def index
    # No Loading because Index page is a search
  end
  
  def show
    @parent = Parent.includes(:notes => [:note_category], :placements => [:comments, :animal => [:animal_type]]).find(params[:id])
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
    temp = params[:q].strip.split
    q = temp.map {|str| str}.join("%")
    @parents = q.blank? ? {} : Parent.search(q)
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid parent => #{params[:id]}")
    flash[:error] = "You have requested an invalid parent!"
    redirect_to parents_path and return
  end
  
end
