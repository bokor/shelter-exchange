require "rails_helper"

feature "Update the Shelter Details" do
  login_user

  background do
    current_shelter.update_attributes({
      :name => "Shelter's Name",
      :phone => "9999999999",
      :fax => "1111111111",
      :email=> "email@shelterexchange.org"
    })
  end

  scenario "successfully save the changes" do
    visit edit_shelter_path(current_shelter)

    fill_in "Name", :with => "cuddle buddies"
    click_button "Update Shelter"

    expect(page.current_path).to eq shelters_path

    page_title_should_be "cuddle buddies"
    expect(find(".page_heading .action_links a")[:href]).to include(shelter_path(current_shelter))
  end

  scenario "cancel the update" do
    visit edit_shelter_path(current_shelter)
    click_link("Cancel")
    expect(current_path).to eq(shelters_path)
  end

  context "when form invalid" do

    scenario "errors are shown to the user" do
      visit edit_shelter_path(current_shelter)

      fill_in "Name", :with => ""
      fill_in "Street Address", :with => ""
      fill_in "Address Line 2", :with => ""
      fill_in "City", :with => ""
      fill_in "Zip Code", :with => ""
      fill_in "Phone", :with => ""
      fill_in "Email", :with => ""

      click_button "Update Shelter"

      expect(page).to have_content "There was a problem with your submission."

      within "#name_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

      within "#address_container" do
        expect(find(".error").text).to eq("Street, city, state and zip code are all required")
      end

      within "#phone_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

      within "#email_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end
    end
  end
end
