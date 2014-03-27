require "spec_helper"

# module AnnouncementsHelper
#
#   def current_announcements
#     Announcement.current_announcements(current_user.announcement_hide_time)
#   end
# end

describe AnnouncementsHelper, "#current_announcements" do

  it "returns no announcements" do
    allow(controller).to receive(:current_user).and_return(User.gen)

    Announcement.gen

    expect(
      helper.current_announcements
    ).to eq([])
  end

  it "returns current announcements" do
    user = User.gen
    user.update_attribute(:announcement_hide_time, nil)

    announcement1 = Announcement.gen
    announcement2 = Announcement.gen

    allow(controller).to receive(:current_user).and_return(user)

    expect(
      helper.current_announcements
    ).to match_array([announcement1, announcement2])
  end
end

