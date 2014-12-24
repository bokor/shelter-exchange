require "rails_helper"

describe "New: Alert Page", :js => :true do
  login_user

  it "should contain correct page title" do
    visit new_alert_path
    page_title_should_be "Create your first alert"
  end

  it "should create a new alert and redirect to index" do
    visit new_alert_path

    fill_in "Title", :with => "Test Title"
    select "High", :from => "Severity *"
    click_button "Create Alert"

    flash_message_should_be "Test Title has been created."

    expect(current_path).to eq(alerts_path)

    expect(find(".title").text).to eq("Test Title")
    expect(find(".high").text).to eq("High")
    expect(find(".created_at_date").text).to eq(Date.today.strftime("%b %d"))
  end

  it "should not create a new alert" do
    visit new_alert_path

    click_button "Create Alert"

    expect(page).to have_content "There was a problem with your submission."

    within "#title_container" do
      expect(find(".error").text).to eq("Cannot be blank")
    end

    within "#severity_container" do
      expect(find(".error").text).to eq("Needs to be selected")
    end

    expect(current_path).to eq(alerts_path)
    body_class_should_include "create_alerts"
  end
end

