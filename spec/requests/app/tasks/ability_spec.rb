require "spec_helper"

describe "Ability: Permissions for the user role on the Index Task Page", :js => :true do
  login_user

  it "should not be able to delete task" do
    current_user.update_attribute(:role, :user)
    Task.gen :shelter => current_shelter

    visit tasks_path
    expect(page).to have_no_content("Delete")
  end
end

