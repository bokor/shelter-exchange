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

  scenario "by default orders accommodations by name" do
    Accommodation.gen :name => "crate", :shelter => current_shelter
    Accommodation.gen :name => "cage", :shelter => current_shelter
    Accommodation.gen :name => "room", :shelter => current_shelter

    visit accommodations_path

    accommodation1 = find(".accommodation:nth-child(1) .accommodation_name").text
    accommodation2 = find(".accommodation:nth-child(2) .accommodation_name").text
    accommodation3 = find(".accommodation:nth-child(3) .accommodation_name").text

    expect(accommodation1).to include("cage")
    expect(accommodation2).to include("crate")
    expect(accommodation3).to include("room")
  end

  scenario "view the animals assigned to accommodation" do
    accommodation = Accommodation.gen :shelter => current_shelter
    status = AnimalStatus.gen :name => "animal status"
    animal = Animal.gen(
      :name => "Billy",
      :sex => "Male",
      :animal_status => status,
      :accommodation => accommodation
    )
    photo = Photo.gen(:attachable => animal, :is_main_photo => false)

    visit accommodations_path

    within "##{dom_id(accommodation)}" do
      click_link "View"

      within ".animal_list" do
        within ".image" do
          expect(find("a")[:href]).to include(animal_path(animal))
          expect(find("img")[:src]).to include(photo.image.url(:thumb))
        end

        expect(find_link("Billy")[:href]).to include(animal_path(animal))
        expect(page).to have_content("Male")
        expect(page).to have_content("animal status")
      end
    end
  end

  scenario "no animals assigned to accommodation" do
    @accommodation = Accommodation.gen :shelter => current_shelter

    visit accommodations_path

    within "##{dom_id(@accommodation)}" do
      click_link "View"
      expect(find(".accommodation_details").text).to eq("No animals in this accommodation")
    end
  end
end

feature "Create new accommodation from the list page" do
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

  context "with location" do

    scenario "adding a new location", :js => true do
      visit accommodations_path

      within "#create_accommodation" do
        click_link "Edit"
      end

      within "#dialog_locations" do
        click_link "Add a location"
        fill_in "Add a location *", :with => "West Coast"
        click_button "Create Location"
      end

      find(".qtip-close").click

      expect(page).to have_select("filters_location_id", options: ["All", "West Coast"])
      expect(page).to have_select("accommodation_location_id", options: ["None", "West Coast"])
    end

    scenario "edit an existing location", :js => true do
      location = Location.gen :name => "West Coast", :shelter => current_shelter

      visit accommodations_path

      within "#create_accommodation" do
        click_link "Edit"
      end

      within "##{dom_id(location)}" do
        click_link "Edit"
      end

      within "##{dom_id(location, :edit)}" do
        fill_in "Add a location *", :with => "East Coast"
        click_button "Update Location"
      end

      find(".qtip-close").click

      expect(page).to have_select("filters_location_id", options: ["All", "East Coast"])
      expect(page).to have_select("accommodation_location_id", options: ["None", "East Coast"])
    end

    scenario "deleting an existing location", :js => true do
      location1 = Location.gen :name => "West Coast", :shelter => current_shelter
      location2 = Location.gen :name => "East Coast", :shelter => current_shelter

      visit accommodations_path

      within "#create_accommodation" do
        click_link "Edit"
      end

      within "##{dom_id(location2)}" do
        click_link "Delete"
        accept_confirmation!
      end

      find(".qtip-close").click

      expect(page).to have_select("filters_location_id", options: ["All", "West Coast"])
      expect(page).to have_select("accommodation_location_id", options: ["None", "West Coast"])
    end
  end
end

feature "Search for accommodations" do
  login_user

  scenario "finds matching records", :js => true do
    found = Accommodation.gen :name => "Cage", :shelter => current_shelter
    not_found = Accommodation.gen :name => "Crate", :shelter => current_shelter

    visit accommodations_path

    fill_in "query", :with => "cage"
    click_button "Go"

    expect(page).to have_css("##{dom_id(found)}")
    expect(page).not_to have_css("##{dom_id(not_found)}")
  end

  scenario "returns no results", :js => true do
    Accommodation.gen :name => "crate", :shelter => current_shelter

    visit accommodations_path

    fill_in "query", :with => "Cage"
    click_button "Go"

    expect(page).to have_content("No Accommodations found")
  end
end

feature "Filter accommodations", :js => true do
  login_user

  scenario "filter by animal type" do
    cute = AnimalType.gen :name => "cute"
    cuddley = AnimalType.gen :name => "cuddley"

    found = Accommodation.gen :animal_type => cute, :shelter => current_shelter
    not_found = Accommodation.gen :animal_type => cuddley, :shelter => current_shelter

    visit accommodations_path

    select "cute", :from => "filters_animal_type_id"

    expect(page).to have_css("##{dom_id(found)}")
    expect(page).not_to have_css("##{dom_id(not_found)}")
  end

  scenario "filter by location" do
    intake_site = Location.gen :name => "intake site", :shelter => current_shelter
    rescue_site = Location.gen :name => "rescue site", :shelter => current_shelter

    found = Accommodation.gen :location => intake_site, :shelter => current_shelter
    not_found = Accommodation.gen :location => rescue_site, :shelter => current_shelter

    visit accommodations_path

    select "intake site", :from => "filters_location_id"

    expect(page).to have_css("##{dom_id(found)}")
    expect(page).not_to have_css("##{dom_id(not_found)}")
  end

  scenario "order results by a-z" do
    Accommodation.gen :name => "crate", :shelter => current_shelter
    Accommodation.gen :name => "cage", :shelter => current_shelter
    Accommodation.gen :name => "room", :shelter => current_shelter

    visit accommodations_path

    select "A-Z", :from => "filters_order_by"

    accommodation1 = find(".accommodation:nth-child(1) .accommodation_name").text
    accommodation2 = find(".accommodation:nth-child(2) .accommodation_name").text
    accommodation3 = find(".accommodation:nth-child(3) .accommodation_name").text

    expect(accommodation1).to include("cage")
    expect(accommodation2).to include("crate")
    expect(accommodation3).to include("room")
  end

  scenario "order results by z-a" do
    Accommodation.gen :name => "crate", :shelter => current_shelter
    Accommodation.gen :name => "cage", :shelter => current_shelter
    Accommodation.gen :name => "room", :shelter => current_shelter

    visit accommodations_path

    select "Z-A", :from => "filters_order_by"

    accommodation1 = find(".accommodation:nth-child(1) .accommodation_name").text
    accommodation2 = find(".accommodation:nth-child(2) .accommodation_name").text
    accommodation3 = find(".accommodation:nth-child(3) .accommodation_name").text

    expect(accommodation1).to include("room")
    expect(accommodation2).to include("crate")
    expect(accommodation3).to include("cage")
  end

  scenario "order results by newest to oldest" do
    Accommodation.gen :name => "crate", :shelter => current_shelter, :updated_at => Time.now - 1.hour
    Accommodation.gen :name => "cage", :shelter => current_shelter, :updated_at => Time.now + 1.hour
    Accommodation.gen :name => "room", :shelter => current_shelter, :updated_at => Time.now

    visit accommodations_path

    select "Newest-Oldest", :from => "filters_order_by"

    accommodation1 = find(".accommodation:nth-child(1) .accommodation_name").text
    accommodation2 = find(".accommodation:nth-child(2) .accommodation_name").text
    accommodation3 = find(".accommodation:nth-child(3) .accommodation_name").text

    expect(accommodation1).to include("cage")
    expect(accommodation2).to include("room")
    expect(accommodation3).to include("crate")
  end

  scenario "order results by oldest to newest" do
    Accommodation.gen :name => "crate", :shelter => current_shelter, :updated_at => Date.new(2014, 02, 14)
    Accommodation.gen :name => "cage", :shelter => current_shelter, :updated_at => Date.new(2013, 02, 14)
    Accommodation.gen :name => "room", :shelter => current_shelter, :updated_at => Date.new(2015, 02, 14)

    visit accommodations_path

    select "Oldest-Newest", :from => "filters_order_by"

    accommodation1 = find(".accommodation:nth-child(1) .accommodation_name").text
    accommodation2 = find(".accommodation:nth-child(2) .accommodation_name").text
    accommodation3 = find(".accommodation:nth-child(3) .accommodation_name").text

    expect(accommodation1).to include("cage")
    expect(accommodation2).to include("crate")
    expect(accommodation3).to include("room")
  end

  scenario "returns no results" do
    intake_site = Location.gen :name => "intake site", :shelter => current_shelter
    rescue_site = Location.gen :name => "rescue site", :shelter => current_shelter

    found = Accommodation.gen :location => intake_site, :shelter => current_shelter

    visit accommodations_path

    select "rescue site", :from => "filters_location_id"

    expect(page).to have_content("No Accommodations found")
  end
end

