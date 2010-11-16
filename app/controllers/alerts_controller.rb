class AlertsController < ApplicationController
  respond_to :html, :js
  
  def index
    @global_alerts = @current_shelter.alerts.for_global.not_stopped.all
    @animal_alerts = @current_shelter.alerts.for_animals.not_stopped.all

    if @global_alerts.blank? and @animal_alerts.blank?
      @alert = @current_shelter.alerts.new
      respond_with(@alert)
    else
      @alert_validate = true
    end
  end
  
  # def show
  #   redirect_to alerts_path and return
  # end
  
  def edit
    begin
      @alert = @current_shelter.alerts.find(params[:id])
      respond_with(@alert)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid alert => #{params[:id]}")
      flash[:error] = "You have requested an invalid alert!"
      redirect_to alerts_path and return
    end
  end

  # def new
  #   @alert = Alert.new
  #   respond_with(@alert)
  # end
  
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
     @alert.destroy
     flash[:notice] = "#{@alert.title} has been deleted."
     respond_with(@alert)
  end
  
  def stopped
    @alert = @current_shelter.alerts.find(params[:id])   
    params[:alert] = { :is_stopped => true }
    flash[:notice] = "Alert has been stopped." if @alert.update_attributes(params[:alert])  
    respond_with(@alert)
  end
  
  # def alert_count_by_scope
  #   if @alert.alertable_type == "Animal"
  #     @count = Alert.for_animals.all.count
  #   else
  #     @count = Alert.for_global.all.count
  #   end
  # end

end
