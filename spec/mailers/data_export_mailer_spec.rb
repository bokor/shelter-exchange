require 'rails_helper'

describe DataExportMailer do

  before do
    @owner = User.gen :email => "owner@example.com", :role => "owner"
    @admin = User.gen :email => "admin@example.com", :role => "admin"
    @user = User.gen :email => "user@example.com", :role => "user"
    @account = Account.gen :users => [@owner, @admin, @user]
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
  end

  it "has a default from email address" do
    expect(DataExportMailer.default[:from]).to eq("ShelterExchange <do-not-reply@shelterexchange.org>")
  end

  it "has a default content type" do
    expect(DataExportMailer.default[:content_type]).to eq("text/html")
  end

  describe ".completed" do

    before do
      @email = DataExportMailer.completed(@shelter)
    end

    it "from the correct sender" do
      expect(@email.from).to eq(["do-not-reply@shelterexchange.org"])
    end

    it "sending to the correct recipient" do
      expect(@email.to).to eq(["owner@example.com", "admin@example.com"])
    end

    it "contains the correct subject" do
      expect(@email.subject).to eq("Mailer Test Shelter's export has completed!")
    end

    it "contains the correct body" do
      expect(@email).to have_content("The data export has completed for #{@shelter.name}. To download the exported zip file, please go to:")
      expect(@email).to have_link("'Export data' tab under 'Account Settings'", :href => "http://#{@account.subdomain}.se.test:9292/settings/export_data")
      expect(@email).to have_content("The zip file contains all relevant csv files, photos and documents.")
    end
  end

  describe ".failed" do

    before do
      @email = DataExportMailer.failed(@shelter)
    end

    it "from the correct sender" do
      expect(@email.from).to eq(["do-not-reply@shelterexchange.org"])
    end

    it "sending to the correct recipient" do
      expect(@email.to).to eq(["owner@example.com", "admin@example.com"])
    end

    it "contains the correct subject" do
      expect(@email.subject).to eq("Mailer Test Shelter's export has failed!")
    end

    it "contains the correct body" do
      expect(@email).to have_content("An error has occured while exporting data for #{@shelter.name}.")
      expect(@email).to have_link("'Export data' tab under 'Account Settings'", :href => "http://#{@account.subdomain}.se.test:9292/settings/export_data")
    end
  end
end

