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
end

