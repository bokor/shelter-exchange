require "spec_helper"

describe "Ability: Permissions for the user role on the Index Alert Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Simulate User access
    @user.role = :user
    @user.save!

    # Create Alert to get to the Index page
    @alert = Alert.gen :shelter => @shelter
  end

  it "should not be able to delete alert" do
    visit alerts_path
    page.should have_no_content("Delete")
  end
end
