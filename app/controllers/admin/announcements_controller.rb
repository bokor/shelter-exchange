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
    flash[:notice] = "#{@announcement.title} has been created." if @announcement.save
    respond_with(@announcement)
  end

  def update
    @announcement = Announcement.find(params[:id])
    flash[:notice] = "#{@announcement.title} has been updated." if @announcement.update_attributes(params[:announcement])
    respond_with(@announcement)
  end

  def destroy
     @announcement = Announcement.find(params[:id])
     flash[:notice] = "#{@announcement.title} has been deleted." if @announcement.destroy
     respond_with(@announcement)
  end
end
