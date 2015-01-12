require "rails_helper"

feature "Delete a task" do
  login_user

  scenario "successfully removes the task", :js => :true do
    task = Task.gen :shelter => current_shelter

    visit tasks_path

    expect(Task.count).to eq(1)

    within "##{dom_id(task)}" do
      click_link('Delete')
      accept_confirmation!
    end

    expect(page).to have_no_content task.details
    expect(Task.count).to eq(0)
  end

  context "incorrect permissions" do
    scenario "role user can not delete a task" do
      current_user.update_attribute(:role, :user)
      Task.gen :shelter => current_shelter

      visit tasks_path
      expect(page).to have_no_content("Delete")
    end
  end
end

