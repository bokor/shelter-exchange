require "rails_helper"

describe "Ability: Permissions for the user role on the Index Capacity Page", :js => :true do
  login_user

  it "should not be able to delete capacity" do
    current_user.update_attribute(:role, :user)
    Capacity.gen :shelter => @shelter

    visit capacities_path
    expect(page).to have_no_content("Delete")
  end
end
