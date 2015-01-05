require "rails_helper"

describe "Ability: Permissions for the user role on the Index Task Page", :js => :true do
  login_user

  it "can not delete task" do
    current_user.update_attribute(:role, :user)
    Task.gen :shelter => current_shelter

    visit tasks_path
    expect(page).to have_no_content("Delete")
  end
end

