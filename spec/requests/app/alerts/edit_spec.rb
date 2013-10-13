require "spec_helper"

describe "Edit: From the Index Alert Page", :js => :true do
  login_user

  it "should update the title" do
    alert = Alert.gen :title => "old title", :shelter => current_shelter

    visit alerts_path

    within "##{dom_id(alert)}" do
      click_link "Edit"
    end

    within "##{dom_id(alert, :edit)}" do
      fill_in "Title", :with => "new title"
      click_button "Update Alert"
    end

    within "##{dom_id(alert)}" do
      page.should have_content "new title"
    end
  end

  it "should change the severity" do
    alert = Alert.gen :title => "low severity title", :shelter => current_shelter, :severity => "low"

    visit alerts_path

    within "##{dom_id(alert)}" do
      click_link "Edit"
    end

    within "##{dom_id(alert, :edit)}" do
      select "High", :from => "Severity *"
      click_button "Update Alert"
    end

    within "##{dom_id(alert)}" do
      find(".details").text.should == "low severity title"
      find(".high").text.should == "High"
      find(".created_at_date").text.should == Date.today.strftime("%b %d")
    end
  end

  it "should change the description" do
    alert = Alert.gen :title => "low severity title", :shelter => current_shelter, :severity => "low"

    visit alerts_path

    within "##{dom_id(alert)}" do
      click_link "Edit"
    end

    within "##{dom_id(alert, :edit)}" do
      fill_in "Description", :with => "changed description"
      click_button "Update Alert"
    end

    within "##{dom_id(alert)}" do
      find(".title", :text => "low severity title").click
      page.should have_content "changed description"
    end
  end
end

