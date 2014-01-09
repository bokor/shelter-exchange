require 'spec_helper'

describe AccountMailer do

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
  end

  it "has a default from email address" do
    AccountMailer.default[:from].should == "ShelterExchange <do-not-reply@shelterexchange.org>"
  end

  it "has a default content type" do
    AccountMailer.default[:content_type].should == "text/html"
  end

  describe ".account_created" do

    before do
      @email = AccountMailer.account_created(@account, @shelter, @user)
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["application@shelterexchange.org"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Shelter Exchange [test] - A new account has been created (Mailer Test Shelter)"
    end

    it "contains the correct body" do
      @email.should have_content("A new account has been created at Shelter Exchange.")
      @email.should have_css("div#message.no_kill", :text => "NO KILL")

      @email.should have_css("h2", :text => "Shelter")
      @email.should have_content("Mailer Test Shelter")
      @email.should have_content("123 Main St Apt B")
      @email.should have_content("Redwood City, CA 94063")
      @email.should have_content("111-222-3333")
      @email.should have_content("blahblah@mailer.com")
      @email.should have_content("http://mailer_works.com")

      @email.should have_css("h2", :text => "Owner")
      @email.should have_content("FirstName LastName")
      @email.should have_content("account_tester@test.com")
    end
  end

  describe ".welcome" do

    before do
      @email = AccountMailer.welcome(@account, @shelter, @user)
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["account_tester@test.com"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Welcome to Shelter Exchange!"
    end

    it "contains an inline attachment" do
      @email.attachments.count.should == 1
      attachment = @email.attachments[0]
      attachment.should be_a_kind_of(Mail::Part)
      attachment.content_type.should be_start_with("image/jpeg")
      attachment.filename.should == "logo_email.jpg"
    end

    it "contains the correct body" do
      attachment_content_id = @email.attachments[0].content_id[1..-1].chop

      email = @email.html_part
      email.should have_css "#email_logo img[src='cid:#{attachment_content_id}']"

      email.should have_content("Hi FirstName,")
      email.should have_content("Thank you for signing up to use Shelter Exchange, I hope our application brings your organization many benefits and much success with saving the lives of the animals in your care.")

      email.should have_content("Please note! Here is your personal URL that provides you direct access to sign in to Shelter Exchange.  We strongly recommend that you bookmark this URL for ease of use to sign in:")

      email.should have_link("http://#{@account.subdomain}.se.test:9292/", :href => "http://#{@account.subdomain}.se.test:9292/")

      email.should have_content("The adoptable animals you enter into the Shelter Exchange application will be available on our public website under the heading")
      email.should have_link("Save a Life", :href => "http://www.shelterexchange.org/save_a_life")
      email.should have_content(". Here you can gain additional exposure from the public to promote adoptions at your facility and we also provide sharing buttons for each animal using Facebook, Twitter and Pinterest.")

      email.should have_content("Shelter Exchange have partnered with Petfinder.com and Adopt-a-pet.com to provide simple automatic uploading of animals to their sites. You can implement the automatic uploads by following the directions here:")
      email.should have_link("Petfinder.com", :href => "http://www.petfinder.com")
      email.should have_link("Adopt-a-pet.com", :href => "http://www.adoptapet.com")

      email.should have_selector("ul") do |list|
        petfinder_link = "http://help.shelterexchange.org/help/kb/community-sharing/upload-animals-to-petfinder"
        list.should have_content("Petfinder - ")
        list.should have_link(petfinder_link, :href => petfinder_link)

        adopt_a_pet_link = "http://help.shelterexchange.org/help/kb/community-sharing/upload-animals-to-adopt-a-petcom"
        list.should have_content("Adopt-a-pet - ")
        list.should have_link(adopt_a_pet_link, :href => adopt_a_pet_link)
      end

      paragraph = "Also, once you have signed in to the application you will notice a button called Community. Here " +
                  "you can view all shelters and rescue groups currently using Shelter Exchange and the animals they have " +
                  "available. This information is only available to shelters and rescue groups that are using Shelter Exchange, " +
                  "as we provide an insight into all animals in need, not just those available for adoption. We encourage " +
                  "you to visit this section often if you can help take in other animals to your facility. This is where we " +
                  "display animals with the greatest needs or the shortest time to live. Additionally if you have animals " +
                  "that you need to share with other groups please ensure you enter them in under the correct status. (For " +
                  "example, a hard behavioral case would be best served as a 'Rescue Candidate.' This informs other rescues " +
                  "that the animal needs assistance and would make an ideal candidate for a rescue group.)"
      email.should have_content(paragraph)

      email.should have_content("We have various help documents that can be found by clicking the Help button at the top right section of the")
      email.should have_content("application window. Here is our Getting Started section to assist with setting up:")

      getting_started_link = "http://help.shelterexchange.org/help/kb/getting-started"
      email.should have_link(getting_started_link, :href => getting_started_link)

      email.should have_content("If you have any questions, suggestions or problems please feel free to post them on our forum discussions board and we will answer as soon as we can!")

      discussions_link = "http://help.shelterexchange.org/help/discussions"
      email.should have_link(discussions_link, :href => discussions_link)

      email.should have_selector(".closing") do |closing|
        closing.should have_content("Kind regards,")
        closing.should have_content("Claire Bokor")
        closing.should have_content("Founder & President")
        closing.should have_content("Shelter Exchange")
        closing.should have_content("Email: claire.bokor@shelterexchange.org")
        closing.should have_link("claire.bokor@shelterexchange.org", :href => "mailto:claire.bokor@shelterexchange.org?subject=Welcome Email")

        shelter_exchange_link = "http://www.shelterexchange.org"
        closing.should have_link(shelter_exchange_link, :href => shelter_exchange_link)

        closing.should have_content("Follow us on Facebook!")
        facebook_link = "http://www.facebook.com/shelterexchange"
        closing.should have_link(facebook_link, :href => facebook_link)
      end
    end
  end
end

