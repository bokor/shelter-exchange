require "rails_helper"

describe "Index: Dashboard Page", :js => :true do
  login_user

  it "should contain the correct page title" do
    visit dashboard_path
    page_title_should_be("Latest Activity")
  end

  context "No activity" do

    it "should display message when no activities" do
      visit dashboard_path
      expect(page).to have_content("No current activity")
    end

    it "should contain a getting started section in the main area" do
      visit dashboard_path

      within "#main" do
        expect(page).to have_content("Getting Started")
        expect(page).to have_link("start a discussion", :href => "http://help.shelterexchange.org/help/discussion/new")
        expect(page).to have_link("Edit shelter details and create a wish list", :href => "http://help.shelterexchange.org/help/kb/getting-started/edit-shelter-details-and-create-a-wish-list")
        expect(page).to have_link("Upload shelter logo", :href => "http://help.shelterexchange.org/help/kb/getting-started/upload-shelter-logo")
        expect(page).to have_link("Set up your shelter capacity", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-your-shelter-capacity")
        expect(page).to have_link("Set up accommodations", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-accommodations")
        expect(page).to have_link("Add your first animal record", :href => "http://help.shelterexchange.org/help/kb/getting-started/add-your-first-animal-record")
      end
    end
  end

  context "Sidebar" do

    it "should have a getting started section" do
      Task.gen :shelter => current_shelter

      visit dashboard_path

      within "#sidebar" do
        expect(page).to have_content("Getting Started")
        expect(page).to have_link("start a discussion", :href => "http://help.shelterexchange.org/help/discussion/new")
        expect(page).to have_link("Edit shelter details and create a wish list", :href => "http://help.shelterexchange.org/help/kb/getting-started/edit-shelter-details-and-create-a-wish-list")
        expect(page).to have_link("Upload shelter logo", :href => "http://help.shelterexchange.org/help/kb/getting-started/upload-shelter-logo")
        expect(page).to have_link("Set up your shelter capacity", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-your-shelter-capacity")
        expect(page).to have_link("Set up accommodations", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-accommodations")
        expect(page).to have_link("Add your first animal record", :href => "http://help.shelterexchange.org/help/kb/getting-started/add-your-first-animal-record")
      end
    end

    it "should have an auto upload section" do
      Task.gen :shelter => current_shelter

      visit dashboard_path

      within "#sidebar .auto_upload" do
        expect(page).to have_content("Auto upload animals")

        list_item = all('ul li')
        expect(list_item[0].find("a")[:href]).to include("/settings/auto_upload")
        expect(list_item[0].find("img")[:src]).to include("/assets/partners/petfinder.png")

        expect(list_item[1].find("a")[:href]).to include("/settings/auto_upload")
        expect(list_item[1].find("img")[:src]).to include("/assets/partners/logo_adopt_a_pet_medium.gif")
      end
    end
  end
end

