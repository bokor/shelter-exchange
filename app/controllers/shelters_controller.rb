class SheltersController < ApplicationController
  respond_to :html, :js
  
  def index
    @shelters = Shelter.all
    respond_with(@shelters)
  end
  
  def show
    begin
      session[:scope] = nil
      @shelter = Shelter.find(params[:id])
      respond_with(@shelter)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid shelter => #{params[:id]}")
      flash[:error] = "You have requested an invalid shelter!"
      redirect_to Shelters_path and return
    end
  end
  
  def edit
    @shelter = Shelter.find(params[:id])
    respond_with(@shelter)
  end
  
  def new
    @shelter = Shelter.new
    respond_with(@shelter)
  end
  
  def create
    @shelter = Shelter.new(params[:Shelter])
    flash[:notice] = "#{@shelter.name} has been created." if @shelter.save
    respond_with(@shelter)
  end
  
  def update
    @shelter = Shelter.find(params[:id])
    flash[:notice] = "#{@shelter.name} has been updated." if @shelter.update_attributes(params[:shelter])      
    respond_with(@shelter)
  end
  
  def destroy
     @shelter = Shelter.find(params[:id])
     @shelter.destroy
     flash[:error] = "#{@shelter.name} has been deleted."
     respond_with(@shelter)
  end


end
