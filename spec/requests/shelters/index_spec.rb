require "spec_helper"

describe "Index: Shelter Page", :js => :true do
  login_user

  before do
    current_shelter.update_attributes({
      :name => "Shelter's Name",
      :phone => "9999999999",
      :fax => "1111111111",
      :email=> "email@shelterexchange.org"
    })
  end

  it "should contain correct page title" do
    visit shelters_path
    page_title_should_be "Shelter's Name"
  end

  it "should have a link to edit the shelter" do
    visit shelters_path
    expect(find(".page_heading .action_links a")[:href]).to include(shelter_path(current_shelter))
  end

  it "should display whether is kill or no kill" do
    visit shelters_path

    within ".shelter_details" do
      expect(find(".shelter_type").text).to eq("No Kill Shelter")
    end

    current_shelter.update_attribute(:is_kill_shelter, true)

    visit shelters_path

    within ".shelter_details" do
      expect(find(".shelter_type").text).to eq("Kill Shelter")
    end
  end

  it "should have an address section" do
    visit shelters_path

    within "#address" do
      expect(find("h3").text).to eq("Address:")
      expect(page).to have_content "Shelter's Name"
      expect(page).to have_content "123 Main St."
      expect(page).to have_content "Apt 101"
      expect(page).to have_content "Redwood City, CA 94063"
    end
  end

  it "should show a map with an icon of the location"

  context "Contact Details" do

    it "should have a contact details section" do
      visit shelters_path

      within "#contact_details" do
        expect(find("h3").text).to eq("Contact Details:")
        expect(page).to have_content "Phone: 999-999-9999"
        expect(page).to have_content "Fax: 111-111-1111"
        expect(page).to have_content "Email: email@shelterexchange.org"
      end
    end

    it "should not show contact detail values" do
      current_shelter.update_attribute(:fax, nil)

      visit shelters_path

      within "#contact_details" do
        expect(page).not_to have_content "Fax: 111-111-1111"
      end
    end
  end

  context "Website Details" do

    it "should have a website details section" do
      visit shelters_path

      within "#website_details" do
        expect(find("h3").text).to eq("Website Details:")
        expect(find_link("Website")[:href]).to include(current_shelter.website)
        expect(find_link("Twitter")[:href]).to eq("http://twitter.com/#!/shelterexchange")
        expect(find_link("Facebook")[:href]).to eq(current_shelter.facebook)
        expect(find_link("Help a Shelter")[:href]).to eq(public_help_a_shelter_url(current_shelter, :subdomain => "www"))
      end
    end

    it "should not show website details values" do
      current_shelter.update_attributes({:website => nil, :twitter => nil, :facebook => nil})

      visit shelters_path

      within "#website_details" do
        expect(page).not_to have_link "Website"
        expect(page).not_to have_link "Twitter"
        expect(page).not_to have_link "Facebook"
      end
    end
  end

  context "Sidebar" do

    it "should display a wish list section with no items"
    it "should display a wish list with items"

  end
end

