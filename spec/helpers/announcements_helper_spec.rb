require "rails_helper"

describe AnnouncementsHelper, "#current_announcements" do

  it "returns no announcements" do
    user = User.gen
    allow(controller).to receive(:current_user).and_return(user)

    Announcement.gen :starts_at => Time.now - 1.month, :ends_at => Time.now + 1.month

    expect(
      helper.current_announcements
    ).to eq([])
  end

  it "returns current announcements" do
    user = User.gen
    user.update_attribute(:announcement_hide_time, DateTime.now - 1.year)

    allow(controller).to receive(:current_user).and_return(user.reload)

    announcement1 = Announcement.gen :starts_at => Time.now - 1.month, :ends_at => Time.now + 1.month
    announcement2 = Announcement.gen :starts_at => Time.now - 1.month, :ends_at => Time.now + 1.month

    expect(
      helper.current_announcements
    ).to match_array([announcement1, announcement2])
  end
end

