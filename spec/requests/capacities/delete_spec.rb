require "rails_helper"

describe "Delete: From the Index Capacity Page", :js => :true do
  login_user

  it "should delete a capacity" do
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
end

