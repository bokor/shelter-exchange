require "rails_helper"

feature "User Authentication and Login Actions for the admin tool" do

  background do
    switch_to_subdomain("manage")
    Owner.gen(:name => "Login Tester", :email => "test@example.com", :password => "testing123", :password_confirmation => "testing123")
  end

  scenario "successfully login an owner" do
    visit "/login"

    fill_in "Email", :with => "test@example.com"
    fill_in "Password", :with => "testing123"
    click_button "Sign in"

    expect(current_url).to eq("http://manage.se.test:9292/admin/dashboard")
  end

  scenario "invalid login credentials" do
    visit "/login"

    click_button "Sign in"
    flash_message_should_be "Invalid email or password."
  end
end

