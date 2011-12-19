class AnnouncementsController < ApplicationController
  respond_to :js

  def destroy
    @announcement = Announcement.find(params[:id]) #last announcement in the list
    set_session(Time.now.utc)
    set_cookies(Time.now.utc)
  end
  
  private
    
    def set_session(time)
      session[:announcement_hide_time] = time
    end

    def set_cookies(time)
      cookies[:announcement_hide_time] = { :value => time.to_datetime.to_s, :expires => @announcement.ends_at }
    end
  
end
  
