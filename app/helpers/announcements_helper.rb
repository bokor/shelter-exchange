module AnnouncementsHelper
  
  def current_announcements
    # hide_time =  session[:announcement_hide_time] || cookies[:announcement_hide_time] || nil
    @current_announcements ||= Announcement.current_announcements(current_user.announcement_hide_time)
  end

end