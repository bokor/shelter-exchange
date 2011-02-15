class AlertsController < ApplicationController
  # load_and_authorize_resource
  respond_to :html, :js
  
  def index
    @shelter_alerts = @current_shelter.alerts.for_shelter.active.all
    @animal_alerts = @current_shelter.alerts.for_animals.active.all

    if @shelter_alerts.blank? and @animal_alerts.blank?
      @alert = @current_shelter.alerts.new
      respond_with(@alert)
    else
      @alert_validate = true
    end
  end
  
  def show
    redirect_to alerts_path and return
  end
  
  def new
    redirect_to alerts_path and return
  end
  
  def edit
    @alert = @current_shelter.alerts.find(params[:id])
    respond_with(@alert)
  end
  
  def create
    @alertable = find_polymorphic_class
    @alert = @current_shelter.alerts.new(params[:alert].merge(:alertable => @alertable))
    
    respond_with(@alert) do |format|
      if @alert.save
        flash[:notice] = "#{@alert.title} has been created."
        format.html { redirect_to alerts_path }
      else
        format.html { render :action => :index }
      end
    end
  end
  
  def update
    @alert = @current_shelter.alerts.find(params[:id])   
    respond_with(@alert) do |format|
      if @alert.update_attributes(params[:alert])  
        flash[:notice] = "#{@alert.title} has been updated."
        format.html { redirect_to alerts_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
  def destroy
     @alert = @current_shelter.alerts.find(params[:id])
     @alert.destroy
     flash[:notice] = "#{@alert.title} has been deleted."
     respond_with(@alert)
  end
  
  def stopped
    @alert = @current_shelter.alerts.find(params[:id])   
    flash[:notice] = "Alert has been stopped." if @alert.update_attributes({ :is_stopped => true })  
  end
  
  # rescue_from ActiveRecord::RecordNotFound do |exception|
  #   logger.error(":::Attempt to access invalid alert => #{params[:id]}")
  #   flash[:error] = "You have requested an invalid alert!"
  #   redirect_to alerts_path and return
  # end

end
