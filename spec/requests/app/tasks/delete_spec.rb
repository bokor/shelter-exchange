require "spec_helper"

describe "Delete: From the Index Task Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Create Task to get to the Index page
    @task = Task.gen :shelter => @shelter
  end

  it "should delete a task" do
    visit tasks_path

    Task.count.should == 1

    within "##{dom_id(@task)}" do
      click_link('Delete')
      accept_confirmation!
    end

    page.should have_no_content @task.details
    Task.count.should == 0
  end
end

