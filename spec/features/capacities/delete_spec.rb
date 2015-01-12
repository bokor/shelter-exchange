require "rails_helper"

feature "Delete a capacity" do
  login_user

  scenario "successfully removes the capacity", :js => :true do
    capacity = Capacity.gen :shelter => current_shelter, :max_capacity => 100

    visit capacities_path

    expect(Capacity.count).to eq(1)

    within "##{dom_id(capacity)}" do
      click_link('Delete')
      accept_confirmation!
    end

    expect(page).to have_no_content "Max capacity: 100"
    expect(Capacity.count).to eq(0)
  end

  context "incorrect permissions" do
    scenario "role user can not delete a capacity" do
      current_user.update_attribute(:role, :user)
      Capacity.gen :shelter => @shelter

      visit capacities_path
      expect(page).to have_no_content("Delete")
    end
  end
end

