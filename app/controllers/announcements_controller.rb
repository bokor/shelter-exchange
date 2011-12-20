class AnnouncementsController < ApplicationController
  respond_to :js

  def hide
    current_user.update_attributes({ :announcement_hide_time => Time.now.utc })
    # session[:announcement_hide_time] = time
    # cookies.permanent[:announcement_hide_time] = time
  end
  
end

  
