require "spec_helper"

describe "Edit: Capacity Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Create Capacity to get to the Index page
    @type     = AnimalType.gen :name => "animal_type"
    @capacity = Capacity.gen :shelter => @shelter, :animal_type => @type, :max_capacity => 4
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
      find(".status").text.should  == "Dog"
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
      find(".counts .max").text.should       == "Max capacity: 250"
      find(".counts .available").text.should == "Available space: 250"
    end
  end

  it "should not update capacity with duplicate Animal type" do
    type = AnimalType.gen :name => "Dog"
    Capacity.gen :shelter => @shelter, :animal_type => type

    visit capacities_path

    within "##{dom_id(@capacity)}" do
      click_link "Edit"
    end

    within "##{dom_id(@capacity, :edit)}" do
      select "Dog", :from => "Animal type *"
      click_button "Update Capacity"

      page.should have_content "There was a problem with your submission."
      find("#animal_type_container .error").text.should == "Is already in use"
    end
  end

  context "Available Space" do

    it "should show current available space for available animals" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 16
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 2
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        page.should have_content "animal_type"
        page.should have_content "Max capacity: 4"
        page.should have_content "Available space: 4"
      end

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        page.should have_content "Max capacity: 4"
        page.should have_content "Available space: 2"
      end
    end

    it "should show green warning when between less than 60% full" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 2
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        page.should have_content "Max capacity: 4"
        page.should have_content "Available space: 3"
        page.should have_css ".circle.green"
      end
    end

    it "should show yellow warning when between 60% - 80% full" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 16
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 2
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 3

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        page.should have_content "Max capacity: 4"
        page.should have_content "Available space: 2"
        page.should have_css ".circle.yellow"
      end
    end

    it "should show red warning when between greater than 80% full" do
      type  = AnimalType.gen :name => "Dog"
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 16
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 1
      Animal.gen :shelter => @shelter, :animal_type => type, :animal_status_id => 16

      visit capacities_path

      within "##{dom_id(@capacity)}" do
        click_link "Edit"
      end

      within "##{dom_id(@capacity, :edit)}" do
        select "Dog", :from => "Animal type *"
        click_button "Update Capacity"
      end

      within "##{dom_id(@capacity)}" do
        page.should have_content "Max capacity: 4"
        page.should have_content "Available space: 0"
        page.should have_css ".circle.red"
      end
    end

  end
end

