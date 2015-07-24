require "rails_helper"

feature "Updating an accommodation" do
  login_user

  scenario "change the name", :js => :true do
    accommodation  = Accommodation.gen :name => "old name", :shelter => current_shelter

    visit accommodations_path

    within "##{dom_id(accommodation)}" do
      click_link "Edit"
    end

    within "##{dom_id(accommodation, :edit)}" do
      fill_in "Name", :with => "new name"
      click_button "Update Accommodation"
    end

    find("##{dom_id(accommodation)}").click

    within "##{dom_id(accommodation)}" do
      expect(page).to have_content "new name"
    end
  end

  scenario "change the type", :js => :true do
    old_type = AnimalType.gen :name => "Dog"
    AnimalType.gen :name => "Cat"

    accommodation  = Accommodation.gen :animal_type => old_type, :shelter => current_shelter

    visit accommodations_path

    within "##{dom_id(accommodation)}" do
      click_link "Edit"
    end

    within "##{dom_id(accommodation, :edit)}" do
      select "Cat", :from => "Animal type *"
      click_button "Update Accommodation"
    end

    find("##{dom_id(accommodation)}").click

    within "##{dom_id(accommodation)}" do
      expect(page).to have_content "Cat"
    end
  end

  scenario "change the max capacity", :js => :true do
    accommodation  = Accommodation.gen :max_capacity => 123, :shelter => current_shelter

    visit accommodations_path

    within "##{dom_id(accommodation)}" do
      click_link "Edit"
    end

    within "##{dom_id(accommodation, :edit)}" do
      fill_in "Max number of animals *", :with => "321"
      click_button "Update Accommodation"
    end

    find("##{dom_id(accommodation)}").click

    within "##{dom_id(accommodation)}" do
      expect(page).to have_content "321"
    end
  end

  scenario "change the location", :js => :true do
    old_location = Location.gen :name => "City", :shelter => current_shelter
    Location.gen :name => "Town", :shelter => current_shelter

    accommodation  = Accommodation.gen :location => old_location, :shelter => current_shelter

    visit accommodations_path

    within "##{dom_id(accommodation)}" do
      click_link "Edit"
    end

    within "##{dom_id(accommodation, :edit)}" do
      select "Town", :from => "Location"
      click_button "Update Accommodation"
    end

    find("##{dom_id(accommodation)}").click

    within "##{dom_id(accommodation)}" do
      expect(page).to have_content "Town"
    end
  end
end

