class AnnouncementsController < ApplicationController
  respond_to :js

  def hide
    session[:announcement_hide_time] = time
    cookies.permanent[:announcement_hide_time] = time
  end
  
end

# @announcement = Announcement.find(params[:id]) #last announcement in the list
# hide_time =  session[:announcement_hide_time] || cookies[:announcement_hide_time] || nil
# current = Announcement.current_announcements(hide_time).order("ends_at desc").limit(1)


#cookies[:announcement_hide_time] = { :value => time, :expires => SOMETIME IN THE FUTURE }
  
