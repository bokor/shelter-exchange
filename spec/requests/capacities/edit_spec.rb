require "rails_helper"

describe "Edit: Capacity Page", :js => :true do
  login_user

  before do
    @capacity = Capacity.gen :shelter => current_shelter, :max_capacity => 4 # Create Capacity to get to the Index page
  end

  it "should update the animal type" do
    AnimalType.gen :name => "Dog"

    visit capacities_path

    within "##{dom_id(@capacity)}" do
      click_link "Edit"
    end

    within "##{dom_id(@capacity, :edit)}" do
      select "Dog", :from => "Animal type *"
      click_button "Update Capacity"
    end

    within "##{dom_id(@capacity)}" do
      expect(page).to have_content("Dog")
    end
  end

  it "should update the max capacity" do
    visit capacities_path

    within "##{dom_id(@capacity)}" do
      click_link "Edit"
    end

    within "##{dom_id(@capacity, :edit)}" do
      fill_in "Max capacity of animals per type *", :with => 250
      click_button "Update Capacity"
    end

    within "##{dom_id(@capacity)}" do
      expect(find(".counts .max").text).to       eq("Max capacity: 250")
      expect(find(".counts .available").text).to eq("Available space: 250")
    end
  end

  it "should not update capacity with duplicate Animal type" do
    type = AnimalType.gen :name => "Dog"
    Capacity.gen :shelter => current_shelter, :animal_type => type

    visit capacities_path

    within "##{dom_id(@capacity)}" do
      click_link "Edit"
    end

    within "##{dom_id(@capacity, :edit)}" do
      select "Dog", :from => "Animal type *"
      click_button "Update Capacity"

      expect(page).to have_content "There was a problem with your submission."
      expect(find("#animal_type_container .error").text).to eq("Is already in use")
    end
  end

  context "Available Space" do

    it "should show current available space for available animals" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 16
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        expect(page).to have_content "Max capacity: 4"
        expect(page).to have_content "Available space: 4"
      end

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        expect(page).to have_content "Max capacity: 4"
        expect(page).to have_content "Available space: 2"
      end
    end

    it "should show green warning when between less than 60% full" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        expect(page).to have_content "Max capacity: 4"
        expect(page).to have_content "Available space: 3"
        expect(page).to have_css ".circle.green"
      end
    end

    it "should show yellow warning when between 60% - 80% full" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 16
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        expect(page).to have_content "Max capacity: 4"
        expect(page).to have_content "Available space: 2"
        expect(page).to have_css ".circle.yellow"
      end
    end

    it "should show red warning when between greater than 80% full" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 16
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => type, :animal_status_id => 16

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        expect(page).to have_content "Max capacity: 4"
        expect(page).to have_content "Available space: 0"
        expect(page).to have_css ".circle.red"
      end
    end

  end
end

