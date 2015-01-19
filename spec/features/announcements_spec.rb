require "rails_helper"

feature "Announcements displayed on all pages" do
  login_user

  xscenario "shows annoucements for valid dates range"
  xscenario "hides announcements"
end

