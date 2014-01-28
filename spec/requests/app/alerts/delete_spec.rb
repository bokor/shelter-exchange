require "spec_helper"

describe "Delete: From the Index Alert Page", :js => :true do
  login_user

  it "should delete an alert" do
    alert = Alert.gen :shelter => current_shelter # Create Alert to get to the Index page

    visit alerts_path

    expect(Alert.count).to eq(1)

    within "##{dom_id(alert)}" do
      click_link('Delete')
      accept_confirmation!
    end

    expect(page).to have_no_content alert.title
    expect(Alert.count).to eq(0)
  end
end

