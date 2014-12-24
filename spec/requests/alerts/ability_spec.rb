require "rails_helper"

describe "Ability: Permissions for the user role on the Index Alert Page", :js => :true do
  login_user

  it "should not be able to delete alert" do
    current_user.update_attribute(:role, :user)
    Alert.gen :shelter => current_shelter # Create Alert to get to the Index page

    visit alerts_path
    expect(page).to have_no_content("Delete")
  end
end
