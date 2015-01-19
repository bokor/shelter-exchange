require "rails_helper"

feature "Announcements" do
  login_user

  background do
    @announcement1 = Announcement.gen(
      :title => "Web update", :message => "Here are the web updates <a href='http://www.google.com'>Google</a>!",
      :starts_at => Time.now - 1.month, :ends_at => Time.now + 1.month)
    @announcement2 = Announcement.gen(
      :title => "Exciting news", :message => "Here is the exciting news!",
      :starts_at => Time.now - 1.month, :ends_at => Time.now + 1.month)
  end

  scenario "shows announcements for valid dates range on all pages" do
    current_user.update_attribute(:announcement_hide_time, DateTime.now - 1.year)

    visit dashboard_path

    within "##{dom_id(@announcement1)}" do
      expect(page).to have_content("Web update")
      expect(page).to have_content("Web update Here are the web updates Google!")
      expect(find_link("Google")[:href]).to eq("http://www.google.com")
    end

    within "##{dom_id(@announcement2)}" do
      expect(page).to have_content("Exciting news")
      expect(page).to have_content("Here is the exciting news!")
    end

    visit animals_path

    within "##{dom_id(@announcement1)}" do
      expect(page).to have_content("Web update")
      expect(page).to have_content("Web update Here are the web updates Google!")
      expect(find_link("Google")[:href]).to eq("http://www.google.com")
    end

    within "##{dom_id(@announcement2)}" do
      expect(page).to have_content("Exciting news")
      expect(page).to have_content("Here is the exciting news!")
    end
  end

  scenario "hides all announcements", :js => true do
    current_user.update_attribute(:announcement_hide_time, DateTime.now - 1.year)

    visit dashboard_path

    within "#announcements" do
      click_link "Hide all"
      accept_confirmation!
    end

    visit dashboard_path

    expect(page).to have_no_selector("#announcements")
  end
end

