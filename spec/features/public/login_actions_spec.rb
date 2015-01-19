require "rails_helper"

feature "User Authentication and Login Actions from the www site" do

  background do
    switch_to_subdomain("www")

    @user = User.gen(:name => "Login Tester", :email => "test@example.com", :password => "testing123", :password_confirmation => "testing123")
    Account.gen(
      :subdomain => "login-test",
      :shelters => [Shelter.gen],
      :users => [@user]
    )
  end

  scenario "successfully login a user" do
    visit "/login"

    fill_in "Email", :with => "test@example.com"
    fill_in "Password", :with => "testing123"
    click_button "Sign in"

    expect(current_url).to eq("http://login-test.se.test:9292/dashboard")
  end

  scenario "invalid login credentials" do
    visit "/login"

    click_button "Sign in"
    flash_message_should_be "Invalid email or password."
  end

  scenario "user forgot their password" do
    Delayed::Worker.delay_jobs = true

    visit "/password/new"

    fill_in "Email", :with => "test@example.com"
    click_button "Send me reset password instructions"

    expect(current_url).to eq("http://www.se.test:9292/login")
    flash_message_should_be "You will receive an email with instructions about how to reset your password in a few minutes."

    expect(Delayed::Job.count).to eq(1)
    Delayed::Worker.new.work_off
    Delayed::Worker.delay_jobs = false

    attachments = ActionMailer::Base.deliveries.last.attachments
    body = ActionMailer::Base.deliveries.last.html_part

    allow(Devise).to receive(:friendly_token).and_return("abcdef")

    expect(body).to have_css "#email_logo img[src='cid:#{attachments[0].content_id[1..-1].chop}']"
    expect(body).to have_content("Dear Login Tester")
    expect(body).to have_content("You are receiving this email as you have requested assistance to reset your password.")
    expect(body).to have_content("Please click this link below to confirm your email address and reset your password.")
    expect(body).to have_link("Change my password", :href => "http://login-test.se.test:9292/password/edit?reset_password_token=#{@user.reload.reset_password_token}")
    expect(body).to have_content("Many thanks,")
    expect(body).to have_content("Shelter Exchange")
    expect(body).to have_link("info@shelterexchange.org", :href => "mailto:info@shelterexchange.org")
    expect(body).to have_link("www.shelterexchange.org", :href => "http://www.shelterexchange.org")
  end
end

