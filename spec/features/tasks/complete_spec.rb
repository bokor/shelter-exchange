require "rails_helper"

feature "Complete a task" do
  login_user

  it "successfully completes a task", :js => :true do
    # Create Task to get to the Index page
    task = Task.gen :shelter => current_shelter

    visit tasks_path

    within "##{dom_id(task)}" do
      check('task_completed')
      accept_confirmation!
    end

    expect(page).to have_no_content task.details
    expect(task.reload).to be_completed
  end
end
