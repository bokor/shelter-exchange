class ParentsController < ApplicationController
  respond_to :html, :js
  
  def index
    # No Loading because Index page is a search
  end
  
  def show
    @parent = Parent.includes(:notes, :placements => [:comments, :animal => [:animal_type]]).find(params[:id])
    @placement = @parent.placements.new
    @comment = @placement.comments.build
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
  
  def find_animals_by_name
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.search_by_name(q).paginate(:per_page => Animal::PER_PAGE, :page => params[:page])
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    logger.error(":::Attempt to access invalid parent => #{params[:id]}")
    flash[:error] = "You have requested an invalid parent!"
    redirect_to parents_path and return
  end
  
end
