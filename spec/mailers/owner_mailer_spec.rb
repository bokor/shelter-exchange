require 'spec_helper'

describe OwnerMailer do

  before do
    allow(Net::FTP).to receive(:open).and_return(true)
  end

  it "has a default from email address" do
    expect(OwnerMailer.default[:from]).to eq("ShelterExchange <do-not-reply@shelterexchange.org>")
  end

  it "has a default content type" do
    expect(OwnerMailer.default[:content_type]).to eq("text/html")
  end

  describe ".account_created" do

    before do
      @account = Account.gen
      @user = User.gen \
        :account_id => @account.id,
        :name => "FirstName LastName",
        :email => "account_tester@test.com",
        :role => "owner"
      @shelter = Shelter.gen \
        :account_id => @account.id,
        :name => "Mailer Test Shelter",
        :street => "123 Main St Apt B",
        :city => "Redwood City",
        :state => "CA",
        :zip_code => "94063",
        :phone => "111-222-3333",
        :email => "blahblah@mailer.com",
        :website => "http://mailer_works.com"

      @email = OwnerMailer.account_created(@account, @shelter, @user)
    end

    it "from the correct sender" do
      expect(@email.from).to eq(["do-not-reply@shelterexchange.org"])
    end

    it "sending to the correct recipient" do
      expect(@email.to).to eq(["application@shelterexchange.org"])
    end

    it "contains the correct subject" do
      expect(@email.subject).to eq("Shelter Exchange [test] - A new account has been created (Mailer Test Shelter)")
    end

    it "contains the correct body" do
      expect(@email).to have_content("A new account has been created at Shelter Exchange.")
      expect(@email).to have_css("div#message.no_kill", :text => "NO KILL")

      expect(@email).to have_css("h2", :text => "Shelter")
      expect(@email).to have_content("Mailer Test Shelter")
      expect(@email).to have_content("123 Main St Apt B")
      expect(@email).to have_content("Redwood City, CA 94063")
      expect(@email).to have_content("111-222-3333")
      expect(@email).to have_content("blahblah@mailer.com")
      expect(@email).to have_content("http://mailer_works.com")

      expect(@email).to have_css("h2", :text => "Owner")
      expect(@email).to have_content("FirstName LastName")
      expect(@email).to have_content("account_tester@test.com")
    end

  end

  describe ".revoked_integration" do

    before do
      @shelter = Shelter.gen :name => "Mailer Test Shelter"
      @integration = Integration.gen :adopt_a_pet, :shelter => @shelter
      @email = OwnerMailer.revoked_integration(@integration)
    end

    it "contains the correct to email address" do
      expect(@email.to).to match_array(["application@shelterexchange.org"])
    end

    it "contains the correct subject" do
      expect(@email.subject).to eq("Auto Upload Error - Mailer Test Shelter(#{@shelter.id})")
    end

    it "contains the correct body" do
      expect(@email).to have_content("Mailer Test Shelter(#{@shelter.id}) \"Adopt a Pet\" Upload not working.")
      expect(@email).to have_link("Admin Page for Mailer Test Shelter", :href => "http://manage.se.test:9292/admin/shelters/#{@shelter.id}")
    end
  end
end

