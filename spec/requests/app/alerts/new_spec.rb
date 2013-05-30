require "spec_helper"

describe "New: Alert Page", :js => :true do

  before do
    @account, @user, @shelter = login
  end

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

    current_path.should == alerts_path

    find(".title").text.should == "Test Title"
    find(".high").text.should == "High"
    find(".created_at_date").text.should == Date.today.strftime("%b %d")
  end

  it "should not create a new alert" do
    visit new_alert_path

    click_button "Create Alert"

    page.should have_content "There was a problem with your submission."

    within "#title_container" do
      find ".error", :text => "Cannot be blank"
    end

    within "#severity_container" do
      find ".error", :text => "Needs to be selected"
    end

    current_path.should == alerts_path
    body_class_should_include "create_alerts"
  end
end

