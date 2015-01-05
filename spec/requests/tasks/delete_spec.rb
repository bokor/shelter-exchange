require "rails_helper"

describe "Delete: From the Index Task Page", :js => :true do
  login_user

  it "deletes a task" do
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
end

