require "spec_helper"

describe "Ability: Permissions for the user role on the Index Capacity Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Simulate User access
    @user.role = :user
    @user.save!

    # Create Capacity to get to the Index page
    @capacity = Capacity.gen :shelter => @shelter
  end

  it "should not be able to delete capacity" do
    visit capacities_path
    page.should have_no_content("Delete")
  end
end
