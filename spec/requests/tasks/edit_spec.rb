require "spec_helper"

describe "Edit: From the Index Task Page", :js => :true do
  login_user

  it "should update the details" do
    task  = Task.gen :details => "old details", :shelter => current_shelter

    visit tasks_path

    within "##{dom_id(task)}" do
      click_link "Edit"
    end

    within "##{dom_id(task, :edit)}" do
      fill_in "Details", :with => "new details"
      click_button "Update Task"
    end

    within "##{dom_id(task)}" do
      expect(page).to have_content "new details"
    end
  end

  it "should change the category icon" do
    task  = Task.gen :details => "call details", :shelter => current_shelter, :category => "call"

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
      expect(page).to have_content("updated category to email")

      image = find(".type img")
      expect(image[:src]).to include("icon_email.png")
      expect(image[:class]).to include("tooltip")
      expect(image[:"data-tip"]).to eq("Email")
    end
  end

  it "should move task from overdue to today" do
    task = Task.gen :details => "Overdue task details", :shelter => current_shelter, :due_date =>  Date.today - 1.day

    visit tasks_path

    within "#overdue_tasks" do
      expect(page).to have_content "Overdue task details"
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
      expect(page).to have_content "Today task details"
    end

    expect(page).to have_no_content "Overdue task details"
  end

  it "should move task from today to tomorrow" do
    task = Task.gen :details => "Today task details", :shelter => current_shelter, :due_date =>  Date.today, :due_category => "today"

    visit tasks_path

    within "#today_tasks" do
      expect(page).to have_content "Today task details"
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
      expect(page).to have_content "Tomorrow task details"
    end

    expect(page).to have_no_content "Today task details"
  end

  it "should move task from tomorrow to later" do
    task = Task.gen :details => "Tomorrow task details", :shelter => current_shelter, :due_date =>  Date.today + 1.day, :due_category => "tomorrow"

    visit tasks_path

    within "#tomorrow_tasks" do
      expect(page).to have_content "Tomorrow task details"
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
      expect(page).to have_content "Later task details"
    end

    expect(page).to have_no_content "Tomorrow task details"
  end

  it "should move task from later to today" do
    task = Task.gen :details => "Later task details", :shelter => current_shelter, :due_date =>  Date.today + 2.day, :due_category => "later"

    visit tasks_path

    within "#later_tasks" do
      expect(page).to have_content "Later task details"
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
      expect(page).to have_content "Today task details"
    end

    expect(page).to have_no_content "Later task details"
  end
end

