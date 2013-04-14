class AnnouncementsController < ApplicationController
  respond_to :js

  def hide
    current_user.update_attributes({ :announcement_hide_time => Time.now.utc })
  end
end

