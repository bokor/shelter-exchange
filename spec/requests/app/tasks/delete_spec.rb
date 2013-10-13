require "spec_helper"

describe "Delete: From the Index Task Page", :js => :true do
  login_user

  it "should delete a task" do
    task = Task.gen :shelter => current_shelter

    visit tasks_path

    Task.count.should == 1

    within "##{dom_id(task)}" do
      click_link('Delete')
      accept_confirmation!
    end

    page.should have_no_content task.details
    Task.count.should == 0
  end
end

