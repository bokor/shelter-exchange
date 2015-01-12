require "rails_helper"

feature "Show the welcome page when no tasks" do
  login_user

  scenario "redirects to 'new' page when there are no tasks" do
    visit tasks_path
    expect(current_path).to eq(new_task_path)
    body_class_should_include "new_tasks"
  end
end

feature "View the task list" do
  login_user

  background do
    # Create Task to get to the Index page
    @task = Task.gen :shelter => current_shelter
  end

  scenario "shows overdue tasks", :js => :true do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Overdue task details"
      fill_in "Additional info", :with => "Overdue task additional info"
      select "Specific date", :from => "When is it due?"

      calendar_datepicker_from("#due_date_container .date_picker", :previous_month)

      click_button "Create Task"
    end

    within "#overdue_tasks" do
      previous_month = (Date.today - 1.month).strftime("%b")
      expect(page).to have_content "#{previous_month} 15"

      find(".task .details .title", :text => "Overdue task details").click
      expect(page).to have_content("Overdue task additional info")
    end
  end

  scenario "shows today tasks", :js => :true do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Today task details"
      fill_in "Additional info", :with => "Today task additional info"
      select "Today", :from => "When is it due?"

      click_button "Create Task"
    end

    within "#today_tasks" do
      find(".task .details .title", :text => "Today task details").click
      expect(page).to have_content("Today task additional info")
    end
  end

  scenario "shows tomorrow tasks", :js => :true do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Tomorrow task details"
      fill_in "Additional info", :with => "Tomorrow task additional info"
      select "Tomorrow", :from => "When is it due?"

      click_button "Create Task"
    end

    within "#tomorrow_tasks" do
      find(".task .details .title", :text => "Tomorrow task details").click
      expect(page).to have_content("Tomorrow task additional info")
    end
  end

  scenario "shows later tasks", :js => :true do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Later task details"
      fill_in "Additional info", :with => "Later task additional info"
      select "Later", :from => "When is it due?"

      click_button "Create Task"
    end

    within "#later_tasks" do
      find(".task .details .title", :text => "Later task details").click
      expect(page).to have_content("Later task additional info")
    end
  end

  scenario "shows specific date on overdue task", :js => :true do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Specific date task details"
      fill_in "Additional info", :with => "Specific date task additional info"
      select "Specific date", :from => "When is it due?"

      calendar_datepicker_from("#due_date_container .date_picker", :previous_month)

      click_button "Create Task"
    end

    within "#overdue_tasks" do
      previous_month = (Date.today - 1.month).strftime("%b")
      expect(page).to have_css "span.task_due_date"
      expect(page).to have_content "#{previous_month} 15"

      find(".task .details .title", :text => "Specific date task details").click
      expect(page).to have_content("Specific date task additional info")
    end
  end

  scenario "shows specific date on later task", :js => :true do
    visit tasks_path

    within "#create_task" do
      fill_in "Details", :with => "Specific date task details"
      fill_in "Additional info", :with => "Specific date task additional info"
      select "Specific date", :from => "When is it due?"

      calendar_datepicker_from("#due_date_container .date_picker", :next_month)

      click_button "Create Task"
    end

    within "#later_tasks" do
      previous_month = (Date.today + 1.month).strftime("%b")
      expect(page).to have_css "span.task_due_date"
      expect(page).to have_content "#{previous_month} 15"

      find(".task .details .title", :text => "Specific date task details").click
      expect(page).to have_content("Specific date task additional info")
    end
  end

  scenario "does not show specific date on today task" do
    task = Task.gen :shelter => current_shelter, :due_category => "specific_date", :due_date => Date.today

    visit tasks_path

    within "##{dom_id(task)}" do
      expect(page).to have_no_css "span.task_due_date"
    end
  end

  scenario "does not show specific date on tomorrow task" do
    task = Task.gen :shelter => current_shelter, :due_category => "specific_date", :due_date => Date.today + 1.day

    visit tasks_path

    within "##{dom_id(task)}" do
      expect(page).to have_no_css "span.task_due_date"
    end
  end

  context "with invalid data" do

    scenario "errors are shown to the user", :js => :true do
      visit tasks_path

      within "#create_task" do
        click_button "Create Task"
      end

      expect(page).to have_content "There was a problem with your submission."

      within "#create_task #details_container" do
        find ".error", :text => "Cannot be blank"
      end
    end
  end

  context "with categories" do

    def should_have_icon_and_tooltip_for(task)
      within "##{dom_id(task)}" do
        expect(page).to have_content "#{task.category.underscore} details"

        image = find(".type img")
        expect(image[:src]).to include("icon_#{task.category.underscore}.png")
        expect(image[:class]).to include("tooltip")
        expect(image[:"data-tip"]).to eq("#{task.category.humanize}")
      end
    end

    scenario "shows icons on each tasks with a specific category" do
      @task.destroy

      call_task        = Task.gen :details => "call details", :shelter => current_shelter, :category => "call"
      email_task       = Task.gen :details => "email details", :shelter => current_shelter, :category => "email"
      follow_up_task   = Task.gen :details => "follow_up details", :shelter => current_shelter, :category => "follow-up"
      meeting_task     = Task.gen :details => "meeting details", :shelter => current_shelter, :category => "meeting"
      to_do_task       = Task.gen :details => "to_do details", :shelter => current_shelter, :category => "to-do"
      alert_task       = Task.gen :details => "alert details", :shelter => current_shelter, :category => "alert"
      educational_task = Task.gen :details => "educational details", :shelter => current_shelter, :category => "educational"
      behavioral_task  = Task.gen :details => "behavioral details", :shelter => current_shelter, :category => "behavioral"
      medical_task     = Task.gen :details => "medical details", :shelter => current_shelter, :category => "medical"

      visit tasks_path

      expect(all(".task").count).to eq(Task::CATEGORIES.count)

      should_have_icon_and_tooltip_for(call_task)
      should_have_icon_and_tooltip_for(email_task)
      should_have_icon_and_tooltip_for(follow_up_task)
      should_have_icon_and_tooltip_for(meeting_task)
      should_have_icon_and_tooltip_for(to_do_task)
      should_have_icon_and_tooltip_for(alert_task)
      should_have_icon_and_tooltip_for(educational_task)
      should_have_icon_and_tooltip_for(behavioral_task)
      should_have_icon_and_tooltip_for(medical_task)
    end

    scenario "does not show icons or tooltips for tasks without a category" do
      task = Task.gen :shelter => current_shelter, :category => nil
      visit tasks_path

      within "##{dom_id(task)}" do
        expect(page).to have_no_css("span.type img.toolip")
      end
    end
  end

  context "with polymorphic association" do

    scenario "links to an animal record" do
      animal = Animal.gen :shelter => current_shelter, :name => "Billy Bob"
      task = Task.gen :shelter => current_shelter, :taskable => animal

      visit tasks_path

      within "##{dom_id(task)}" do
        expect(page).to have_css "span.taskable_link"
        expect(page).to have_link "Billy Bob"
      end
    end

    scenario "does not link to an animal record" do
      task = Task.gen :shelter => current_shelter, :taskable => nil

      visit tasks_path

      within "##{dom_id(task)}" do
        expect(page).to have_no_css "span.taskable_link"
      end
    end
  end
end

