require "spec_helper"

describe "Edit: From the Index Task Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Create Task to get to the Index page
    @task = Task.gen :shelter => @shelter
  end

  it "should update the details" do
    task  = Task.gen :details => "old details", :shelter => @shelter

    visit tasks_path

    within "##{dom_id(task)}" do
      click_link "Edit"
    end

    within "##{dom_id(task, :edit)}" do
      fill_in "Details", :with => "new details"
      click_button "Update Task"
    end

    within "##{dom_id(task)}" do
      page.should have_content "new details"
    end
  end

  it "should change the category icon" do
    task  = Task.gen :details => "call details", :shelter => @shelter, :category => "call"

    visit tasks_path

    within "##{dom_id(task)}" do
      click_link "Edit"
    end

    within "##{dom_id(task, :edit)}" do
      fill_in "Details", :with => "updated category to email"
      select "Email", :from => "Category"
      click_button "Update Task"
    end

    within "##{dom_id(task)}" do
      page.should have_content("updated category to email")

      image = find(".type img")
      image[:src].should include("icon_email.png")
      image[:class].should include("tooltip")
      image[:"data-tip"].should == "Email"
    end
  end

  it "should move task from overdue to today" do
    task = Task.gen :details => "Overdue task details", :shelter => @shelter, :due_date =>  Date.today - 1.day

    visit tasks_path

    within "#overdue_tasks" do
      page.should have_content "Overdue task details"
    end

    within "##{dom_id(task)}" do
      click_link("Edit")
    end

    within "##{dom_id(task, :edit)}" do
      fill_in "Details", :with => "Today task details"
      select "Today", :from => "When is it due?"
      click_button "Update Task"
    end

    within "#today_tasks" do
      page.should have_content "Today task details"
    end

    within "#overdue_tasks" do
      page.should have_no_content "Overdue task details"
      page.should have_no_content "Today task details"
    end
  end

  it "should move task from today to tomorrow" do
    task = Task.gen :details => "Today task details", :shelter => @shelter, :due_date =>  Date.today, :due_category => "today"

    visit tasks_path

    within "#today_tasks" do
      page.should have_content "Today task details"
    end

    within "##{dom_id(task)}" do
      click_link("Edit")
    end

    within "##{dom_id(task, :edit)}" do
      fill_in "Details", :with => "Tomorrow task details"
      select "Tomorrow", :from => "When is it due?"
      click_button "Update Task"
    end

    within "#tomorrow_tasks" do
      page.should have_content "Tomorrow task details"
    end

    within "#today_tasks" do
      page.should have_no_content "Today task details"
      page.should have_no_content "Tomorrow task details"
    end
  end

  it "should move task from tomorrow to later" do
    task = Task.gen :details => "Tomorrow task details", :shelter => @shelter, :due_date =>  Date.today + 1.day, :due_category => "tomorrow"

    visit tasks_path

    within "#tomorrow_tasks" do
      page.should have_content "Tomorrow task details"
    end

    within "##{dom_id(task)}" do
      click_link("Edit")
    end

    within "##{dom_id(task, :edit)}" do
      fill_in "Details", :with => "Later task details"
      select "Later", :from => "When is it due?"
      click_button "Update Task"
    end

    within "#later_tasks" do
      page.should have_content "Later task details"
    end

    within "#tomorrow_tasks" do
      page.should have_no_content "Tomorrow task details"
      page.should have_no_content "Later task details"
    end
  end

  it "should move task from later to today" do
    task = Task.gen :details => "Later task details", :shelter => @shelter, :due_date =>  Date.today + 2.day, :due_category => "later"

    visit tasks_path

    within "#later_tasks" do
      page.should have_content "Later task details"
    end

    within "##{dom_id(task)}" do
      click_link("Edit")
    end

    within "##{dom_id(task, :edit)}" do
      fill_in "Details", :with => "Today task details"
      select "Today", :from => "When is it due?"
      click_button "Update Task"
    end

    within "#today_tasks" do
      page.should have_content "Today task details"
    end

    within "#later_tasks" do
      page.should have_no_content "Today task details"
      page.should have_no_content "Later task details"
    end
  end
end

