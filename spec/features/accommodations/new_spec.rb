require "rails_helper"

feature "Welcome page for accommodations" do
  login_user

  background do
    AnimalType.gen :name => "Dog"
  end

  scenario "creates a new accommodation and redirect to index", :js => true do
    visit new_accommodation_path

    select "Dog", :from => "Animal type *"
    fill_in "Name *", :with => "Crate 1"
    fill_in "Max number of animals *", :with => "2"

    click_button "Create Accommodation"

    flash_message_should_be "Crate 1 accommodation has been created."

    expect(current_path).to eq(accommodations_path)
    expect(find(".accommodation_name").text).to include("Crate 1")
  end

  context "with invalid data" do

    scenario "errors are shown to the user" do
      visit new_accommodation_path

      click_button "Create Accommodation"

      expect(page).to have_content "There was a problem with your submission."

      within "#animal_type_container" do
        expect(find(".error").text).to eq("Needs to be selected")
      end

      within "#name_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

      within "#max_capacity_container" do
        expect(find(".error").text).to eq("Requires a number")
      end

      expect(current_path).to eq(accommodations_path)
      body_class_should_include "create_accommodations"
    end
  end

  context "with location" do

    scenario "adding a new location", :js => true do
      visit new_accommodation_path

      click_link "Edit"

      within "#dialog_locations" do
        click_link "Add a location"
        fill_in "Add a location *", :with => "West Coast"
        click_button "Create Location"
      end

      find(".qtip-close").click

      select "West Coast", :from => "Location"
      select "Dog", :from => "Animal type *"
      fill_in "Name *", :with => "Crate 1"
      fill_in "Max number of animals *", :with => "2"

      click_button "Create Accommodation"

      expect(find(".location_details").text).to include("West Coast")
    end

    scenario "edit an existing location", :js => true do
      location = Location.gen :name => "West Coast", :shelter => current_shelter

      visit new_accommodation_path

      click_link "Edit"

      within "##{dom_id(location)}" do
        click_link "Edit"
      end

      within "##{dom_id(location, :edit)}" do
        fill_in "Add a location *", :with => "East Coast"
        click_button "Update Location"
      end

      find(".qtip-close").click

      expect(page).to have_select("accommodation_location_id", options: ["None", "East Coast"])

      select "East Coast", :from => "Location"
      select "Dog", :from => "Animal type *"
      fill_in "Name *", :with => "Crate 1"
      fill_in "Max number of animals *", :with => "2"

      click_button "Create Accommodation"

      expect(find(".location_details").text).to include("East Coast")
    end

    scenario "deleting an existing location", :js => true do
      location1 = Location.gen :name => "West Coast", :shelter => current_shelter
      location2 = Location.gen :name => "East Coast", :shelter => current_shelter

      visit new_accommodation_path

      click_link "Edit"

      within "##{dom_id(location2)}" do
        click_link "Delete"
        accept_confirmation!
      end

      find(".qtip-close").click

      expect(page).to have_select("accommodation_location_id", options: ["None", "West Coast"])

      select "West Coast", :from => "Location"
      select "Dog", :from => "Animal type *"
      fill_in "Name *", :with => "Crate 1"
      fill_in "Max number of animals *", :with => "2"

      click_button "Create Accommodation"

      expect(find(".location_details").text).to include("West Coast")
    end
  end
end

