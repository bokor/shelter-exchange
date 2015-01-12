require "rails_helper"

feature "Announcements" do
  login_user

  xscenario "shows annoucements for valid dates range"
  xscenario "hides announcements"
  xscenario "shows new ones"
end

