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

  it "should complete a task" do
    visit tasks_path

    within "##{dom_id(@task)}" do
      check('task_completed')
      accept_confirmation!
    end

    page.should have_no_content @task.details
    @task.reload.should be_completed
  end
end
