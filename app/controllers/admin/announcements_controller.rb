class Admin::AnnouncementsController < Admin::ApplicationController
  respond_to :html, :js
  
  def index
    @announcements = Announcement.all
  end
  
  def edit
    @announcement = Announcement.find(params[:id])
    respond_with(@announcement)
  end
  
  def create
    @announcement = Announcement.new(params[:announcement])
    
    respond_with(@announcement) do |format|
      if @announcement.save
        flash[:notice] = "#{@announcement.title} has been created."
        format.html { redirect_to announcements_path }
      else
        format.html { render :action => :new }
      end
    end
  end
  
  def update
    @announcement = Announcement.find(params[:id])   
    respond_with(@announcement) do |format|
      if @announcement.update_attributes(params[:announcement])  
        flash[:notice] = "#{@announcement.title} has been updated."
        format.html { redirect_to announcements_path }
      else
        format.html { render :action => :edit }
      end
    end
  end
  
  def destroy
     @announcement = Announcement.find(params[:id])
     flash[:notice] = "#{@announcement.title} has been deleted." if @announcement.destroy
     respond_with(@announcement)
  end
  
end