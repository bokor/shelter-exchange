require "rails_helper"

feature "Show the welcome page when no capacities" do
  login_user

  scenario "redirects to 'new' page when there are no tasks" do
    visit capacities_path
    expect(current_path).to eq(new_capacity_path)
    body_class_should_include "new_capacities"
  end
end

feature "View the capacity list" do
  login_user

  background do
    # Create Capacity to get to the Index page
    @type     = AnimalType.gen :name => "animal_type"
    @capacity = Capacity.gen :shelter => current_shelter, :animal_type => @type
  end

  it "show new capacity" do
    AnimalType.gen :name => "Dog"

    visit capacities_path

    within "#create_capacity" do
      select "Dog", :from => "Animal type *"
      fill_in "Max capacity of animals per type *", :with => "100"
      click_button "Create Capacity"
    end

    expect(page).to have_content "Dog"
    expect(page).to have_content "Max capacity: 100"
    expect(page).to have_content "Available space: 100"
  end

  context "with invalid data" do

    scenario "errors are shown to the user", :js => :true do
      visit capacities_path

      within "#create_capacity" do
        click_button "Create Capacity"
      end

      expect(page).to have_content "There was a problem with your submission."

      within "#animal_type_container" do
        expect(find(".error").text).to eq("Needs to be selected")
      end

      within "#max_capacity_container" do
        expect(find(".error").text).to eq("Requires a number")
      end
    end

    scenario "error occurs with duplicate animal type", :js => :true do
      visit capacities_path

      within "#create_capacity" do
        select "animal_type", :from => "Animal type *"
        fill_in "Max capacity of animals per type *", :with => "100"
        click_button "Create Capacity"
      end

      expect(page).to have_content "There was a problem with your submission."

      within "#animal_type_container" do
        expect(find(".error").text).to eq("Is already in use")
      end
    end
  end

  context "with available space" do

    background do
      @type     = AnimalType.gen :name => "Dog"
      @capacity = Capacity.gen :shelter => current_shelter, :animal_type => @type, :max_capacity => 4
    end

    scenario "shows current available space for available animals" do
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 16
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        expect(page).to have_content "Max capacity: 4"
        expect(page).to have_content "Available space: 2"
      end
    end

    scenario "shows green warning when between less than 60% full" do
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        expect(page).to have_css ".circle.green"
      end
    end

    scenario "shows yellow warning when between 60% - 80% full" do
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 16
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        expect(page).to have_css ".circle.yellow"
      end
    end

    scenario "shows red warning when between greater than 80% full" do
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 16
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 16

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        expect(page).to have_css ".circle.red"
      end
    end
  end
end

