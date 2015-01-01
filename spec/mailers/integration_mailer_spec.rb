require 'rails_helper'

describe IntegrationMailer do

  before do
    allow(Net::FTP).to receive(:open).and_return(true)
  end

  it "has a default from email address" do
    expect(IntegrationMailer.default[:from]).to eq("ShelterExchange <do-not-reply@shelterexchange.org>")
  end

  it "has a default content type" do
    expect(IntegrationMailer.default[:content_type]).to eq("text/html")
  end

  describe ".revoked" do

    before do
      @shelter = Shelter.gen :name => "Mailer Test Shelter"
      @user1 = User.gen :name => "Joe User"
      @user2 = User.gen :name => "Joe User"
      Account.gen(:subdomain => "mailertest", :shelters => [@shelter], :users => [@user1, @user2])

      @integration = Integration.gen :adopt_a_pet, :shelter => @shelter
      @email = IntegrationMailer.revoked(@integration)
    end

    it "sending to the correct recipient" do
      expect(@email.to).to match_array([@shelter.email, @user1.email, @user2.email])
    end

    it "contains the correct subject" do
      expect(@email.subject).to eq("Your Shelter Exchange Auto Upload is no longer working")
    end

    it "contains an inline attachment" do
      expect(@email.attachments.count).to eq(1)
      attachment = @email.attachments[0]
      expect(attachment).to be_a_kind_of(Mail::Part)
      expect(attachment.content_type).to be_start_with("image/jpeg")
      expect(attachment.filename).to eq("logo_email.jpg")
    end

    it "contains the correct body" do
      attachment_content_id = @email.attachments[0].content_id[1..-1].chop

      email = @email.html_part
      expect(email).to have_css "#email_logo img[src='cid:#{attachment_content_id}']"

      expect(email).to have_content("Hello!")
      expect(email).to have_content("We have detected an error and can no longer upload your animal data to Adopt a Pet because your FTP Username and FTP Password in no longer valid.")
      expect(email).to have_content("Please click this link to re-enter your FTP & Password:")
      expect(email).to have_link("http://mailertest.se.test:9292/settings/auto_upload", :href => "http://mailertest.se.test:9292/settings/auto_upload")

      expect(email).to have_content("If you have questions, please feel free to email us:")
      expect(email).to have_link("info@shelterexchange.org", :href => "mailto:info@shelterexchange.org?subject=Revoked Auto Upload - Adopt a Pet - #{@shelter.name}(#{@shelter.id})")

      expect(email).to have_selector(".closing") do |closing|
        expect(closing).to have_content("Many thanks,")
        expect(closing).to have_content("Shelter Exchange Team")
      end
    end
  end
end

