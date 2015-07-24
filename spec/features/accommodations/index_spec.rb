require "rails_helper"

feature "Show the welcome page when no accommodations" do
  login_user

  scenario "redirects to 'new' page when there are no accommodations" do
    visit accommodations_path
    expect(current_path).to eq(new_accommodation_path)
    body_class_should_include "new_accommodations"
  end
end

feature "View the accommodation list" do
  login_user

  background do
    AnimalType.gen :name => "Dog"
    AnimalType.gen :name => "Cat"

    # Create Accommodation to get to the Index page
    @accommodation = Accommodation.gen :shelter => current_shelter
  end

  scenario "shows new accommodation", :js => :true do
    Location.gen :name => "Testing Town", :shelter => current_shelter
    visit accommodations_path

    within "#create_accommodation" do
      select "Testing Town", :from => "Location"
      select "Cat", :from => "Animal type *"
      fill_in "Name *", :with => "Cuddle Room"
      fill_in "Max number of animals *", :with => "3"

      click_button "Create Accommodation"
    end

    within "#accommodations .accommodation_list" do
      expect(page).to have_content("Testing Town")
      expect(page).to have_content("Cuddle Room")
      expect(page).to have_content("Cat")
      expect(page).to have_content("3")
    end
  end

  context "with invalid data" do

    scenario "errors are shown to the user", :js => :true do
      visit accommodations_path

      within "#create_accommodation" do
        click_button "Create Accommodation"
      end

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
    end
  end

  scenario "view animals"
  scenario "searching"
  scenario "filtering"
end


