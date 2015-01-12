require "rails_helper"

feature "View the Shelter Details" do
  login_user

  background do
    current_shelter.update_attributes({
      :name => "Shelter's Name",
      :phone => "9999999999",
      :fax => "1111111111",
      :email=> "email@shelterexchange.org"
    })
  end

  scenario "shows the shelter's name" do
    visit shelters_path
    page_title_should_be "Shelter's Name"
    expect(find(".page_heading .action_links a")[:href]).to include(shelter_path(current_shelter))
  end

  scenario "shows no kill shelter" do
    visit shelters_path

    within ".shelter_details" do
      expect(find(".shelter_type").text).to eq("No Kill Shelter")
    end
  end

  scenario "shows kill shelter" do
    current_shelter.update_attribute(:is_kill_shelter, true)

    visit shelters_path

    within ".shelter_details" do
      expect(find(".shelter_type").text).to eq("Kill Shelter")
    end
  end

  scenario "shows the address" do
    visit shelters_path

    within "#address" do
      expect(find("h3").text).to eq("Address:")
      expect(page).to have_content "Shelter's Name"
      expect(page).to have_content "123 Main St."
      expect(page).to have_content "Apt 101"
      expect(page).to have_content "Redwood City, CA 94063"
    end
  end

  scenario "shows the correct contact information" do
    visit shelters_path

    within "#contact_details" do
      expect(find("h3").text).to eq("Contact Details:")
      expect(page).to have_content "Phone: 999-999-9999"
      expect(page).to have_content "Fax: 111-111-1111"
      expect(page).to have_content "Email: email@shelterexchange.org"
    end

    current_shelter.update_attribute(:fax, nil)

    visit shelters_path

    within "#contact_details" do
      expect(page).not_to have_content "Fax: 111-111-1111"
    end
  end

  scenario "shows the website details" do
    visit shelters_path

    within "#website_details" do
      expect(find("h3").text).to eq("Website Details:")
      expect(find_link("Website")[:href]).to include(current_shelter.website)
      expect(find_link("Twitter")[:href]).to eq("http://twitter.com/#!/shelterexchange")
      expect(find_link("Facebook")[:href]).to eq(current_shelter.facebook)
      expect(find_link("Help a Shelter")[:href]).to include(public_help_a_shelter_path(current_shelter, :subdomain => "www"))
    end

    current_shelter.update_attributes({:website => nil, :twitter => nil, :facebook => nil})

    visit shelters_path

    within "#website_details" do
      expect(page).not_to have_link "Website"
      expect(page).not_to have_link "Twitter"
      expect(page).not_to have_link "Facebook"
    end
  end
end

