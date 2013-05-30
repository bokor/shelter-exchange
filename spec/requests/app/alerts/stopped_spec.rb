require "spec_helper"

describe "Stopped: From the Index Alert Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Create Alert to get to the Index page
    @alert = Alert.gen :shelter => @shelter
  end

  it "should stop an alert" do
    visit alerts_path

    within "##{dom_id(@alert)}" do
      check('alert_stopped')
      accept_confirmation!
    end

    page.should have_no_content @alert.title
    @alert.reload.should be_stopped
  end
end


