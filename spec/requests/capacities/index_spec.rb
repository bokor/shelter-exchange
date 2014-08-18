require "spec_helper"

describe "Index: Capacity Page", :js => :true do
  login_user

  before do
    # Create Capacity to get to the Index page
    @type     = AnimalType.gen :name => "animal_type"
    @capacity = Capacity.gen :shelter => current_shelter, :animal_type => @type
  end

  it "should contain correct page title" do
    visit capacities_path
    page_title_should_be "Shelter capacity"
  end

  it "should redirect to 'new' page when there are no tasks" do
    @capacity.destroy

    visit capacities_path
    expect(current_path).to eq(new_capacity_path)
    body_class_should_include "new_capacities"
  end

  it "should not create a new capacity" do
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

  it "should not create a new capacity with duplicate Animal type" do
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

  it "should show new capacity" do
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

  context "Available Space" do

    before do
      @type     = AnimalType.gen :name => "Dog"
      @capacity = Capacity.gen :shelter => current_shelter, :animal_type => @type, :max_capacity => 4
    end

    it "should show current available space for available animals" do
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

    it "should show green warning when between less than 60% full" do
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        expect(page).to have_css ".circle.green"
      end
    end

    it "should show yellow warning when between 60% - 80% full" do
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 1
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 16
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 2
      Animal.gen :shelter => current_shelter, :animal_type => @type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        expect(page).to have_css ".circle.yellow"
      end
    end

    it "should show red warning when between greater than 80% full" do
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

