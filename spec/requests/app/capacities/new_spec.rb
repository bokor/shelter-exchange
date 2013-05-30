require "spec_helper"

describe "New: Capacity Page", :js => :true do

  before do
    @account, @user, @shelter = login
  end

  it "should contain correct page title" do
    visit new_capacity_path
    page_title_should_be "Create your Shelter Capacity List"
  end

  it "should create a new capacity and redirect to index" do
    AnimalType.gen :name => "Dog"

    visit new_capacity_path

    select "Dog", :from => "Animal type *"
    fill_in "Max capacity of animals per type *", :with => "100"
    click_button "Create Capacity"

    flash_message_should_be "Shelter Capacity has been created."

    current_path.should == capacities_path

    find(".status .green").text.should     == "Dog"
    find(".counts .max").text.should       == "Max capacity: 100"
    find(".counts .available").text.should == "Available space: 100"
  end

  it "should not create a new capacity" do
    visit new_capacity_path

    click_button "Create Capacity"

    page.should have_content "There was a problem with your submission."

    within "#animal_type_container" do
      find(".error").text.should == "Needs to be selected"
    end

    within "#max_capacity_container" do
      find(".error").text.should == "Requires a number"
    end

    current_path.should == capacities_path
    body_class_should_include "create_capacities"
  end
end


