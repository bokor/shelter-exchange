require "spec_helper"

describe "New: Task Page", :js => :true do

  before do
    @account, @user, @shelter = login
  end

  it "should contain correct page title" do
    visit new_task_path
    page_title_should_be "Create your first task"
  end

  it "should create a new task and redirect to index" do
    visit new_task_path

    fill_in "Details", :with => "Test Title"
    click_button "Create Task"

    flash_message_should_be "Task has been created."

    current_path.should == tasks_path
    page.should have_content "Test Title"
  end

  it "should not create a new task" do
    visit new_task_path

    click_button "Create Task"

    page.should have_content "There was a problem with your submission."

    within "#details_container" do
      find ".error", :text => "Cannot be blank"
    end

    current_path.should == tasks_path
    body_class_should_include "create_tasks"
  end
end

