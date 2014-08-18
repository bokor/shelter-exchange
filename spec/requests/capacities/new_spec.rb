require "spec_helper"

describe "New: Capacity Page", :js => :true do
  login_user

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

    expect(current_path).to eq(capacities_path)

    expect(find(".status .green").text).to     eq("Dog")
    expect(find(".counts .max").text).to       eq("Max capacity: 100")
    expect(find(".counts .available").text).to eq("Available space: 100")
  end

  it "should not create a new capacity" do
    visit new_capacity_path

    click_button "Create Capacity"

    expect(page).to have_content "There was a problem with your submission."

    within "#animal_type_container" do
      expect(find(".error").text).to eq("Needs to be selected")
    end

    within "#max_capacity_container" do
      expect(find(".error").text).to eq("Requires a number")
    end

    expect(current_path).to eq(capacities_path)
    body_class_should_include "create_capacities"
  end
end


