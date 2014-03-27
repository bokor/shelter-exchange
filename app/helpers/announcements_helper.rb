module AnnouncementsHelper

  def current_announcements
    Announcement.current_announcements(current_user.announcement_hide_time)
  end
end

