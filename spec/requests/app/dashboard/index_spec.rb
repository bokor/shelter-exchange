require "spec_helper"

describe "Index: Dashboard Page", :js => :true do
  login_user

  it "should contain the correct page title" do
    visit dashboard_path
    page_title_should_be("Latest Activity")
  end

  context "No activity" do

    it "should display message when no activities" do
      visit dashboard_path
      page.should have_content("No current activity")
    end

    it "should contain a getting started section in the main area" do
      visit dashboard_path

      within "#main" do
        page.should have_content("Getting Started")
        page.should have_link("start a discussion", :href => "http://help.shelterexchange.org/help/discussion/new")
        page.should have_link("Edit shelter details and create a wish list", :href => "http://help.shelterexchange.org/help/kb/getting-started/edit-shelter-details-and-create-a-wish-list")
        page.should have_link("Upload shelter logo", :href => "http://help.shelterexchange.org/help/kb/getting-started/upload-shelter-logo")
        page.should have_link("Set up your shelter capacity", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-your-shelter-capacity")
        page.should have_link("Set up accommodations", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-accommodations")
        page.should have_link("Add your first animal record", :href => "http://help.shelterexchange.org/help/kb/getting-started/add-your-first-animal-record")
      end
    end
  end

  context "Sidebar" do

    it "should have a getting started section" do
      Task.gen :shelter => current_shelter

      visit dashboard_path

      within "#sidebar" do
        page.should have_content("Getting Started")
        page.should have_link("start a discussion", :href => "http://help.shelterexchange.org/help/discussion/new")
        page.should have_link("Edit shelter details and create a wish list", :href => "http://help.shelterexchange.org/help/kb/getting-started/edit-shelter-details-and-create-a-wish-list")
        page.should have_link("Upload shelter logo", :href => "http://help.shelterexchange.org/help/kb/getting-started/upload-shelter-logo")
        page.should have_link("Set up your shelter capacity", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-your-shelter-capacity")
        page.should have_link("Set up accommodations", :href => "http://help.shelterexchange.org/help/kb/getting-started/set-up-accommodations")
        page.should have_link("Add your first animal record", :href => "http://help.shelterexchange.org/help/kb/getting-started/add-your-first-animal-record")
      end
    end

    it "should have an auto upload section" do
      Task.gen :shelter => current_shelter

      visit dashboard_path

      within "#sidebar .auto_upload" do
        page.should have_content("Auto upload animals")

        list_item = all('ul li')
        list_item[0].find("a")[:href].should include("/settings/auto_upload")
        list_item[0].find("img")[:src].should include("/assets/partners/petfinder.png")

        list_item[1].find("a")[:href].should include("/settings/auto_upload")
        list_item[1].find("img")[:src].should include("/assets/partners/logo_adopt_a_pet_medium.gif")
      end
    end
  end
end

