require "spec_helper"

describe "Ability: Permissions for the user role on the Index Task Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Simulate User access
    @user.role = :user
    @user.save!

    # Create Task to get to the Index page
    @task = Task.gen :shelter => @shelter
  end

  it "should not be able to delete task" do
    visit tasks_path
    page.should have_no_content("Delete")
  end
end

