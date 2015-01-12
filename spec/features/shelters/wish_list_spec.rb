require "rails_helper"

feature "Manage Wish list" do
  login_user

  background do
    Item.gen :shelter => current_shelter, :name => "blankets"
    Item.gen :shelter => current_shelter, :name => "food"
    Item.gen :shelter => current_shelter
    Item.gen :shelter => current_shelter
    Item.gen :shelter => current_shelter
  end

  scenario "change the wish list", :js => true do
    visit shelters_path

    within "#items_section" do
      expect(page).to have_content "blankets"
      expect(page).to have_content "food"
    end

    find("#edit_wish_list", :text => "Edit").click

    within "#edit_items" do
      find_field("shelter_items_attributes_0_name").set("donations")
      find_field("shelter_items_attributes_1_name").set("food")
      find_field("shelter_items_attributes_2_name").set("love")

      click_button("Update list")
    end

    within "#items" do
      expect(page).to have_content "donations"
      expect(page).to have_content "food"
      expect(page).to have_content "love"

      expect(page).not_to have_content "blankets"
    end
  end
end

