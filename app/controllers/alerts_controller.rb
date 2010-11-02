class AlertsController < ApplicationController
  respond_to :html, :js
  
  def index
    @alerts = Alert.all
    respond_with(@alerts)
  end
  
  # def show
  #   # begin
  #     @alert = Alert.find(params[:id])
  #     respond_with(@alert)
  #   # rescue ActiveRecord::RecordNotFound
  #     # logger.error(":::Attempt to access invalid animal => #{params[:id]}")
  #     # flash[:error] = "You have requested an invalid animal!"
  #     # redirect_to animals_path and return
  #   # end
  # end
  
  def edit
    @alert = Alert.find(params[:id])
    respond_with(@alert)
  end
  
  def new
    @alert = Alert.new
    respond_with(@alert)
  end
  
  def create
    @alert = Alert.new(params[:alert])
    flash[:notice] = "#{@alert.title} has been created." if @alert.save
    respond_to do |format|  
      format.html { redirect_to alerts_url }
      format.js 
    end
  end
  
  def update
    @alert = Alert.find(params[:id])
    flash[:notice] = "#{@alert.title} has been updated." if @alert.update_attributes(params[:alert])      
    respond_to do |format|  
      format.html { redirect_to alerts_url }
      format.js 
    end
  end
  
  def destroy
     @alert = Alert.find(params[:id])
     @alert.destroy
     respond_with(@alert)
  end

end
