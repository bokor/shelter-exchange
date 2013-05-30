require "spec_helper"

describe "Delete: From the Index Alert Page", :js => :true do

  before do
    @account, @user, @shelter = login
    # Create Alert to get to the Index page
    @alert = Alert.gen :shelter => @shelter
  end

  it "should delete a alert" do
    visit alerts_path

    Alert.count.should == 1

    within "##{dom_id(@alert)}" do
      click_link('Delete')
      accept_confirmation!
    end

    page.should have_no_content @alert.title
    Alert.count.should == 0
  end
end
