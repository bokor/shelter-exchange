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
    expect(current_path).to eq(new_alert_path)
    body_class_should_include "new_alerts"
  end

  it "should not create a new alert" do
    visit alerts_path

    within "#create_alert" do
      click_button "Create Alert"
    end

    expect(page).to have_content "There was a problem with your submission."

    within "#create_alert #title_container" do
      expect(find(".error").text).to eq("Cannot be blank")
    end

    within "#create_alert #severity_container" do
      expect(find(".error").text).to eq("Needs to be selected")
    end
  end

  it "should show a section title" do
    visit alerts_path
    expect(find("#shelter_alerts_section h3").text).to eq("Shelter")
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
      expect(page).to have_content "High alert"
      expect(page).to have_content "High"
      expect(page).to have_content Date.today.strftime("%b %d")

      expect(page).to have_content "Low alert"
      expect(page).to have_content "Low"
      expect(page).to have_content Date.today.strftime("%b %d")
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
      expect(page).to have_no_content "This is a high alert description"
      find(".title", :text => "High alert").click
      expect(page).to have_content "This is a high alert description"
      find(".title", :text => "High alert").click
      expect(page).to have_no_content "This is a high alert description"
    end
  end

  context "Sorting" do

    it "should order the alerts from when they were created" do
      @alert.destroy
      alert1 = Alert.gen :shelter => current_shelter, :created_at => Time.now - 2.days
      alert2 = Alert.gen :shelter => current_shelter, :created_at => Time.now - 4.days
      alert3 = Alert.gen :shelter => current_shelter, :created_at => Time.now - 1.days

      visit alerts_path

      expect(page.body).to match(/#{dom_id(alert3)}.*?#{dom_id(alert1)}.*?#{dom_id(alert2)}/m)
    end
  end

  context "Alertable" do

    before do
      animal        = Animal.gen :shelter => current_shelter, :name => "Billy Bob"
      @animal_alert = Alert.gen :shelter => current_shelter, :alertable => animal
    end

    it "should show a section title" do
      visit alerts_path
      expect(find("#animal_alerts_section h3").text).to eq("Animal")
    end

    it "should have a link to an animal record" do
      visit alerts_path

      within "##{dom_id(@animal_alert)}" do
        expect(page).to have_css "span.alertable_link"
        expect(page).to have_link "Billy Bob"
      end
    end

    it "should not have a link to an animal record" do
      visit alerts_path

      within "##{dom_id(@alert)}" do
        expect(page).to have_no_css "span.alertable_link"
      end
    end
  end
end

