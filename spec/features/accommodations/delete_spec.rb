require "rails_helper"

feature "Delete an accommodation" do
  login_user

  scenario "successfully removes the accommodation", :js => :true do
    accommodation = Accommodation.gen :shelter => current_shelter

    visit accommodations_path

    expect(Accommodation.count).to eq(1)

    within "##{dom_id(accommodation)}" do
      click_link('Delete')
      accept_confirmation!
    end

    expect(page).to have_no_content accommodation.name
    expect(Accommodation.count).to eq(0)
  end

  context "incorrect permissions" do
    scenario "role user can not delete a accommodation" do
      current_user.update_attribute(:role, :user)
      Accommodation.gen :shelter => current_shelter

      visit accommodations_path
      expect(page).to have_no_content("Delete")
    end
  end
end

