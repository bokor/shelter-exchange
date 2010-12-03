class ParentsController < ApplicationController
  # before_filter :authenticate_user!
  respond_to :html, :js
  
  def index
    @parents = Parent.all #(:include => [:parent_type, :parent_status])
    respond_with(@parents)
  end
  
  def show
    begin
      @parent = Parent.find(params[:id])
      respond_with(@parent)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid parent => #{params[:id]}")
      flash[:error] = "You have requested an invalid parent!"
      redirect_to parents_path and return
    end
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
    q = params[:q].strip
    @parents = q.blank? ? {} : Parent.search(q)
    respond_with(@parents)
  end
  
  def search_animal_by_name
    q = params[:q].strip
    @animals = q.blank? ? {} : @current_shelter.animals.search_by_name(q)
  end
  
end
