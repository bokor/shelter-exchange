require "rails_helper"

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
      expect(page).to have_content "new title"
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
      expect(find(".details").text).to eq("low severity title")
      expect(find(".high").text).to eq("High")
      expect(find(".created_at_date").text).to eq(Date.today.strftime("%b %d"))
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
      expect(page).to have_content "changed description"
    end
  end
end

