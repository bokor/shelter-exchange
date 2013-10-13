require "spec_helper"

describe "Index: Alert Page", :js => :true do
  login_user

  before do
    @alert = Alert.gen :shelter => current_shelter # Create Alert to get to the Index page
  end

  it "should contain correct page title" do
    visit alerts_path
    page_title_should_be "Alerts"
  end

  it "should redirect to 'new' page when there are no alerts" do
    @alert.destroy

    visit alerts_path
    current_path.should == new_alert_path
    body_class_should_include "new_alerts"
  end

  it "should not create a new alert" do
    visit alerts_path

    within "#create_alert" do
      click_button "Create Alert"
    end

    page.should have_content "There was a problem with your submission."

    within "#create_alert #title_container" do
      find(".error").text.should == "Cannot be blank"
    end

    within "#create_alert #severity_container" do
      find(".error").text.should == "Needs to be selected"
    end
  end

  it "should show a section title" do
    visit alerts_path
    find("#shelter_alerts_section h3").text.should == "Shelter"
  end

  it "should create new shelter alerts" do
    visit alerts_path

    within "#create_alert" do
      fill_in "Title", :with => "High alert"
      select "High", :from => "Severity *"

      click_button "Create Alert"
    end

    within "#create_alert" do
      fill_in "Title", :with => "Low alert"
      select "Low", :from => "Severity *"

      click_button "Create Alert"
    end

    within "#shelter_alerts" do
      page.should have_content "High alert"
      page.should have_content "High"
      page.should have_content Date.today.strftime("%b %d")

      page.should have_content "Low alert"
      page.should have_content "Low"
      page.should have_content Date.today.strftime("%b %d")
    end
  end

  it "should show and hide the description" do
    visit alerts_path

    within "#create_alert" do
      fill_in "Title", :with => "High alert"
      select "High", :from => "Severity *"
      fill_in "Description", :with => "This is a high alert description"

      click_button "Create Alert"
    end

    within "#shelter_alerts" do
      page.should have_no_content "This is a high alert description"
      find(".title", :text => "High alert").click
      page.should have_content "This is a high alert description"
      find(".title", :text => "High alert").click
      page.should have_no_content "This is a high alert description"
    end
  end

  context "Sorting" do

    it "should order the alerts from when they were created" do
      @alert.destroy
      alert1 = Alert.gen :shelter => current_shelter, :created_at => Time.now - 2.days
      alert2 = Alert.gen :shelter => current_shelter, :created_at => Time.now - 4.days
      alert3 = Alert.gen :shelter => current_shelter, :created_at => Time.now - 1.days

      visit alerts_path

      page.body.should =~ /#{dom_id(alert3)}.*?#{dom_id(alert1)}.*?#{dom_id(alert2)}/m
    end
  end

  context "Alertable" do

    before do
      animal        = Animal.gen :shelter => current_shelter, :name => "Billy Bob"
      @animal_alert = Alert.gen :shelter => current_shelter, :alertable => animal
    end

    it "should show a section title" do
      visit alerts_path
      find("#animal_alerts_section h3").text.should == "Animal"
    end

    it "should have a link to an animal record" do
      visit alerts_path

      within "##{dom_id(@animal_alert)}" do
        page.should have_css "span.alertable_link"
        page.should have_link "Billy Bob"
      end
    end

    it "should not have a link to an animal record" do
      visit alerts_path

      within "##{dom_id(@alert)}" do
        page.should have_no_css "span.alertable_link"
      end
    end
  end
end

