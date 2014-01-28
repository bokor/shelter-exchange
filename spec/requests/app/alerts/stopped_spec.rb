require "spec_helper"

describe "Stopped: From the Index Alert Page", :js => :true do
  login_user

  it "should stop an alert" do
    alert = Alert.gen :shelter => current_shelter

    visit alerts_path

    within "##{dom_id(alert)}" do
      check('alert_stopped')
      accept_confirmation!
    end

    expect(page).to have_no_content alert.title
    expect(alert.reload).to be_stopped
  end
end

