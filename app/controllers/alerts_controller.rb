class AlertsController < ApplicationController
  load_and_authorize_resource :only => [:new]
  # caches_action :index
  # cache_sweeper :alert_sweeper
  
  respond_to :html, :js
  
  def index
    @shelter_alerts = @current_shelter.alerts.for_shelter.active.all
    @animal_alerts = @current_shelter.alerts.for_animals.active.all

    if @shelter_alerts.blank? and @animal_alerts.blank?
      redirect_to new_alert_path
    else
      @alert_validate = true
    end
  end
  
  def new
    @alert = @current_shelter.alerts.new
    respond_with(@alert)
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
        format.html { render :action => :new }
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
     flash[:notice] = "#{@alert.title} has been deleted." if @alert.destroy
     respond_with(@alert)
  end
  
  def stopped
    @alert = @current_shelter.alerts.find(params[:id])   
    flash[:notice] = "Alert has been stopped." if @alert.update_attributes({ :is_stopped => true })  
    respond_with(@alert)
  end

end