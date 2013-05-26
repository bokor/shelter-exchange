require "spec_helper"

describe "Index: Task Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Create Task to get to the Index page
    @task = Task.gen :shelter => @shelter
  end

  it "should contain correct page title" do
    visit tasks_path
    page_title_should_be "Tasks"
  end

  it "should redirect to new page when there are no tasks" do
    @task.destroy

    visit tasks_path
    current_path.should == new_task_path
    body_class_should_include "new_tasks"
  end

  it "should not create a new task" do
    visit tasks_path

    within "#create_task" do
      click_button "Create Task"
    end

    page.should have_content "There was a problem with your submission."

    within "#create_task #details_container" do
      find ".error", :text => "Cannot be blank"
    end
  end

  it "should show overdue tasks" do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Overdue task details"
      select "Specific date", :from => "When is it due?"

      calendar_date_select_from("#due_date_container .date_picker", :previous_month)

      click_button "Create Task"
    end

    within "#overdue_tasks" do
      previous_month = (Date.today - 1.month).strftime("%b")
      page.should have_content "#{previous_month} 15"
      page.should have_content "Overdue task details"
    end
  end

  it "should show today tasks" do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Today task details"
      select "Today", :from => "When is it due?"

      click_button "Create Task"
    end

    within "#today_tasks" do
      page.should have_content "Today task details"
    end
  end

  it "should show tomorrow tasks" do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Tomorrow task details"
      select "Tomorrow", :from => "When is it due?"

      click_button "Create Task"
    end

    within "#tomorrow_tasks" do
      page.should have_content "Tomorrow task details"
    end
  end

  it "should show later tasks" do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Later task details"
      select "Later", :from => "When is it due?"

      click_button "Create Task"
    end

    within "#later_tasks" do
      page.should have_content "Later task details"
    end
  end

  it "should show specific date tasks for later" do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Specific date task details"
      select "Specific date", :from => "When is it due?"

      calendar_date_select_from("#due_date_container .date_picker", :next_month)

      click_button "Create Task"
    end

    within "#later_tasks" do
      previous_month = (Date.today + 1.month).strftime("%b")
      page.should have_content "#{previous_month} 15"
      page.should have_content "Specific date task details"
    end
  end

  context "Categories" do

    def should_have_icon_and_tooltip_for(task)
      within "##{dom_id task}" do
        page.should have_content "#{task.category.underscore} details"

        image = find(".type img")
        image[:src].should include("icon_#{task.category.underscore}.png")
        image[:class].should include("tooltip")
        image[:"data-tip"].should == "#{task.category.humanize}"
      end
    end

    it "should show icons on each tasks with a specific category" do
      @task.destroy

      call_task        = Task.gen :details => "call details", :shelter => @shelter, :category => "call"
      email_task       = Task.gen :details => "email details", :shelter => @shelter, :category => "email"
      follow_up_task   = Task.gen :details => "follow_up details", :shelter => @shelter, :category => "follow-up"
      meeting_task     = Task.gen :details => "meeting details", :shelter => @shelter, :category => "meeting"
      to_do_task       = Task.gen :details => "to_do details", :shelter => @shelter, :category => "to-do"
      educational_task = Task.gen :details => "educational details", :shelter => @shelter, :category => "educational"
      behavioral_task  = Task.gen :details => "behavioral details", :shelter => @shelter, :category => "behavioral"
      medical_task     = Task.gen :details => "medical details", :shelter => @shelter, :category => "medical"

      visit tasks_path

      all(".task").count.should == Task::CATEGORIES.count

      should_have_icon_and_tooltip_for(call_task)
      should_have_icon_and_tooltip_for(email_task)
      should_have_icon_and_tooltip_for(follow_up_task)
      should_have_icon_and_tooltip_for(meeting_task)
      should_have_icon_and_tooltip_for(to_do_task)
      should_have_icon_and_tooltip_for(educational_task)
      should_have_icon_and_tooltip_for(behavioral_task)
      should_have_icon_and_tooltip_for(medical_task)
    end

    it "should not icons or tooltips for tasks without a category" do
      task = Task.gen :shelter => @shelter, :category => nil
      visit tasks_path

      within "##{dom_id task}" do
        page.should have_no_css(".type img.toolip")
      end
    end
  end

  context "Edit" do
    it "should move task from overdue to today"
    it "should move task from today to tomorrow"
    it "should move task from tomorrow to later"
    it "should move task from later to today"
  end

  context "Delete" do
    it "should delete a task"
    it "should not delete a task"
  end

  context "Complete" do
    it "should complete a task"
    it "should not complete a task"
  end

  context "Taskable" do
    it "should have a link an animal record" do
    #<span class="details">
      #<span class="title"><%= task.details %> <%= show_taskable_link(task) %></span>
    #</span>
    end
  end
end

