require "spec_helper"

describe "Index: Shelter Page", :js => :true do

  before do
    @account, @user, @shelter = login

    @shelter.update_attributes({
      :name            => "Shelter's Name",
      :phone           => "9999999999",
      :fax             => "1111111111",
      :email           => "email@shelterexchange.org"
    })
  end

  it "should contain correct page title" do
    visit shelters_path
    page_title_should_be "Shelter's Name"
  end

  it "should have a link to edit the shelter" do
    visit shelters_path
    find(".page_heading .action_links a")[:href].should include(shelter_path(@shelter))
  end

  it "should display whether is kill or no kill" do
    visit shelters_path

    within ".shelter_details" do
      find(".shelter_type").text.should == "No Kill Shelter"
    end

    @shelter.update_attributes({ :is_kill_shelter => true })

    visit shelters_path

    within ".shelter_details" do
      find(".shelter_type").text.should == "Kill Shelter"
    end
  end

  it "should have an address section" do
    visit shelters_path

    within "#address" do
      find("h3").text.should == "Address:"
      page.should have_content "Shelter's Name"
      page.should have_content "123 Main St."
      page.should have_content "Apt 101"
      page.should have_content "Redwood City, CA 94063"
    end
  end

  it "should show a map with an icon of the location"

  context "Contact Details" do

    it "should have a contact details section" do
      visit shelters_path

      within "#contact_details" do
        find("h3").text.should == "Contact Details:"
        page.should have_content "Phone: 999-999-9999"
        page.should have_content "Fax: 111-111-1111"
        page.should have_content "Email: email@shelterexchange.org"
      end
    end

    it "should not show contact detail values" do
      @shelter.update_attributes({:fax => nil})

      visit shelters_path

      within "#contact_details" do
        page.should_not have_content "Fax: 111-111-1111"
      end
    end
  end

  context "Website Details" do

    it "should have a website details section" do
      visit shelters_path

      within "#website_details" do
        find("h3").text.should == "Website Details:"
        find_link("Website")[:href].should include(@shelter.website)
        find_link("Twitter")[:href].should == "http://twitter.com/#!/shelterexchange"
        find_link("Facebook")[:href].should == @shelter.facebook
        find_link("Help a Shelter")[:href].should == public_help_a_shelter_url(@shelter, :subdomain => "www")
      end
    end

    it "should not show website details values" do
      @shelter.update_attributes({
        :website  => nil,
        :twitter  => nil,
        :facebook => nil
      })

      visit shelters_path

      within "#website_details" do
        page.should_not have_link "Website"
        page.should_not have_link "Twitter"
        page.should_not have_link "Facebook"
      end
    end
  end

  context "Sidebar" do

    it "should display a wish list section with no items"
    it "should display a wish list with items"

  end
end
