require "rails_helper"

feature "Signing up a new user" do

  background do
    switch_to_subdomain("www")
  end

  scenario "creates a new account" do
    visit "/signup"

    within "#shelter_name_container" do
      fill_in "Name", :with => "Test Name"
    end

    within "#shelter_address_container" do
      fill_in "Street Address", :with => "123 main st."
      fill_in "Address Line 2", :with => "#101"
      fill_in "City", :with => "Redwood City"
      select "California", :from => "State"
      fill_in "Zip Code", :with => "94063"
    end

    within "#shelter_phone_container" do
      fill_in "Main phone", :with => "999-999-9999"
    end

    within "#shelter_email_container" do
      fill_in "Email", :with => "example@example.com"
    end

    within "#shelter_timezone_container" do
      select "Pacific Time (US & Canada)", :from => "Time Zone"
    end

    within "#account_document_type_container" do
      choose "501(c)(3) determination letter"
    end

    within "#account_document_container" do
      file_path = Rails.root.join("spec/data/documents/testing.pdf")
      attach_file("Upload document", file_path)
    end

    within "#user_name_container" do
      fill_in "First and Last name", :with => "SE User"
     end

    within "#user_email_container" do
      fill_in "Email", :with => "se_user@example.com"
    end

    within "#user_password_container" do
      fill_in "Password", :with => "testing"
    end

    within "#user_password_confirmation_container" do
      fill_in "Confirm Password", :with => "testing"
    end

    within "#account_subdomain_container" do
      fill_in "Subdomain", :with => "happy-shelter"
    end

    click_button "Create new account"

    account = Account.last
    expect(current_path).to eq(registered_public_account_path(account))
    page_title_should_be("Welcome Test Name")
  end

  scenario "correctly format the subdomain", :js => true do
    visit "/signup"

    within "#shelter_name_container" do
      fill_in "Name", :with => "Test Name"
    end

    within "#account_subdomain_container" do
      expect(
        find("#account_subdomain").value
      ).to eq("testname")
    end

    within "#shelter_name_container" do
      fill_in "Name", :with => "Changed shelter name"
    end

    within "#account_subdomain_container" do
      expect(
        find("#account_subdomain").value
      ).to eq("changedsheltername")
    end

    within "#account_subdomain_container" do
      fill_in "Subdomain", :with => "happy-shelter-123TESTING-----"
    end

    click_button "Create new account"

    within "#account_subdomain_container" do
      expect(
        find("#account_subdomain").value
      ).to eq("happy-shelter-123testing")
    end
  end

  context "with invalid data" do

    scenario "errors are shown to the user" do
      visit "/signup"

      click_button "Create new account"

      expect(page).to have_content "There was a problem with your submission."

			within "#shelter_name_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

			within "#shelter_address_container" do
        expect(find(".error").text).to eq("Street, city, state and zip code are all required")
      end

			within "#shelter_phone_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

			within "#shelter_email_container" do
        expect(find(".error").text).to eq("Cannot be blank")
			end

      within "#shelter_timezone_container" do
        expect(find(".error").text).to eq("Is not a valid us time zone")
			end

      within "#account_document_type_container" do
        expect(find(".error").text).to eq("Is not included in the list")
			end

      within "#account_document_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

      within "#user_name_container" do
        expect(find(".error").text).to eq("Cannot be blank")
      end

      within "#user_email_container" do
        expect(find(".error").text).to eq("Cannot be blank")
			end

      within "#user_password_container" do
        expect(find(".error").text).to eq("Cannot be blank")
			end

      within "#account_subdomain_container" do
        expect(find(".error").text).to eq("Cannot be blank and can only contain letters, numbers, or hyphens. no spaces allowed!")
      end
    end

    scenario "password confirmation error" do
      visit "/signup"

      within "#user_password_container" do
        fill_in "Password", :with => "testing"
      end

      within "#user_password_confirmation_container" do
        fill_in "Confirm Password", :with => "not_the_same"
      end

      click_button "Create new account"

      expect(page).to have_content "There was a problem with your submission."

      within "#user_password_container" do
        expect(find(".error").text).to eq("Doesn't match confirmation")
			end
    end
  end
end

