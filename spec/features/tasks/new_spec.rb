require "rails_helper"

feature "Welcome page for tasks" do
  login_user

  scenario "creates a new task and redirect to index", :js => true do
    visit new_task_path

    fill_in "Details", :with => "Test Title"
    fill_in "Additional info", :with => "Test Additional info"
    click_button "Create Task"

    flash_message_should_be "Task has been created."

    expect(current_path).to eq(tasks_path)
    expect(find(".details").text).to eq("Test Title")
    find(".task").click
    expect(find(".additional_info").text).to eq("Test Additional info")
  end

  context "with invalid data" do

    scenario "errors are shown to the user" do
      visit new_task_path

      click_button "Create Task"

      expect(page).to have_content "There was a problem with your submission."

      within "#details_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

      expect(current_path).to eq(tasks_path)
      body_class_should_include "create_tasks"
    end
  end
end



