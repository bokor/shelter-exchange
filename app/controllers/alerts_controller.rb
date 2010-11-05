class AlertsController < ApplicationController
  respond_to :html, :js
  
  def index
    @alerts = Alert.all
    respond_with(@alerts)
  end
  
  def show
    redirect_to alerts_path and return
  end
  
  def edit
    begin
      @alert = Alert.find(params[:id])
      respond_with(@alert)
    rescue ActiveRecord::RecordNotFound
      logger.error(":::Attempt to access invalid alert => #{params[:id]}")
      flash[:error] = "You have requested an invalid alert!"
      redirect_to alerts_path and return
    end
  end

  def new
    @alert = Alert.new
    respond_with(@alert)
  end
  
  def create
    @alertable = find_polymorphic_class
    @alert = Alert.new(params[:alert].merge(:alertable => @alertable))
    
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
    @alert = Alert.find(params[:id])   
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
     @alert = Alert.find(params[:id])
     @alert.destroy
     flash[:error] = "#{@alert.title} has been deleted."
     respond_with(@alert)
  end

end
