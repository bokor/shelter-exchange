require "spec_helper"

describe "Completed: From the Index Task Page", :js => :true do
  login_user

  it "should complete a task" do
    task = Task.gen :shelter => current_shelter # Create Task to get to the Index page

    visit tasks_path

    within "##{dom_id(task)}" do
      check('task_completed')
      accept_confirmation!
    end

    page.should have_no_content task.details
    task.reload.should be_completed
  end
end

