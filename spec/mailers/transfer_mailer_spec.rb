require 'spec_helper'

describe TransferMailer do

  before do
    requestor_shelter = Shelter.gen \
      :name => "Shelter Wanna Help",
      :street => "123 Needs Help Lane",
   	  :city => "Mountain View",
      :state => "CA",
      :zip_code => "94043",
      :phone => "999-888-7777",
      :email => "wants_to_help@shelter.com"

    shelter = Shelter.gen \
      :name => "Shelter Needs Help",
      :street => "123 Main St Apt B",
   	  :city => "Redwood City",
      :state => "CA",
      :zip_code => "94063",
      :phone => "111-222-3333",
      :email => "needs_the_help@shelter.com"

    animal = Animal.gen :shelter => shelter, :name => "Cutie"

    @transfer = Transfer.gen \
      :requestor_shelter => requestor_shelter,
      :shelter => shelter,
      :animal => animal,
      :email => "need_animal@help.com",
      :requestor => "Jim Helper",
      :phone => "123-456-7890"
  end

  it "has a default from email address" do
    TransferMailer.default[:from].should == "ShelterExchange <do-not-reply@shelterexchange.org>"
  end

  it "has a default content type" do
    TransferMailer.default[:content_type].should == "text/html"
  end

  describe ".requestor_new_request" do

    before do
      @email = TransferMailer.requestor_new_request(@transfer)
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["need_animal@help.com"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Requested Transfer from Shelter Needs Help"
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

      email.should have_content("Thank you!")
      email.should have_content("You have requested Cutie from Shelter Needs Help and an email notification has been sent to notify them of your request.")
      email.should have_content("If the transfer is approved by Shelter Needs Help you will receive an email notifying you of this. You must make the necessary arrangements to pull or collect this animal in accordance with their procedures and guidelines.")
      email.should have_content("Once the animal has been transported to your shelter the record for Cutie will be transferred to your animal database within Shelter Exchange. If you are having difficultly locating the record please contact the Shelter Needs Help to ensure they have clicked the 'Complete' button on the Dashboard page, this will transfer the record to your shelter.")
      email.should have_content("Please consult directly with the shelter regarding all transfer requests that you have sent, their contact details are below:")

      email.should have_css("strong", :text => "Shelter Needs Help")
      email.should have_content("123 Main St Apt B")
      email.should have_content("Apt 101")
      email.should have_content("Redwood City, CA 94063")
      email.should have_content("Tel: 111-222-3333")
      email.should have_content("Email: needs_the_help@shelter.com")
      email.should have_link("needs_the_help@shelter.com", :href => "mailto:needs_the_help@shelter.com")

      email.should have_selector(".closing") do |closing|
        closing.should have_content("Kind regards,")
        closing.should have_content("Shelter Exchange Team")
      end
    end
  end

  describe ".requestee_new_request" do

    before do
      @email = TransferMailer.requestee_new_request(@transfer, "**transfer_history_text**")
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["needs_the_help@shelter.com"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Requested Transfer from Shelter Wanna Help by Jim Helper"
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

      email.should have_content("A transfer request has been submitted for Cutie. Below are the details of the shelter or rescue that wish to transfer this animal to their facility.")

      email.should have_css("strong", :text => "Shelter Wanna Help")
      email.should have_content("123 Needs Help Lane")
      email.should have_content("Apt 101")
      email.should have_content("Mountain View, CA 94043")
      email.should have_content("Tel: 999-888-7777")
      email.should have_content("Email: wants_to_help@shelter.com")
      email.should have_link("wants_to_help@shelter.com", :href => "mailto:wants_to_help@shelter.com")

      email.should have_content("Contact: Jim Helper")
      email.should have_content("Tel: 123-456-7890")
      email.should have_content("Email: need_animal@help.com")
      email.should have_link("need_animal@help.com", :href => "mailto:need_animal@help.com")

      email.should have_css(".additional_notes", :text => "Addtional Notes: **transfer_history_text**")

      email.should have_content("Sign into Shelter Exchange and click on the 'Dashboard' to view this pending request. Please Approve or Reject this request in accordance with your internal adoption and rescue procedures.")
      email.should have_content("If you APPROVE this request and the animal has been transferred from your shelter (or is in transit to the new shelter) please click COMPLETE on the Dashboard page to transfer the animal record to the new shelter.")

      email.should have_selector(".closing") do |closing|
        closing.should have_content("Kind regards,")
        closing.should have_content("Shelter Exchange Team")
      end
    end
  end

  describe ".approved" do

    before do
      @email = TransferMailer.approved(@transfer, "**approved_transfer_history_text**")
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["need_animal@help.com"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Transfer Request from Shelter Needs Help for Cutie - Approved"
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

      email.should have_content("Congratulations! Your request to transfer Cutie to your shelter or rescue has been Approved by Shelter Needs Help. Any details regarding this transfer request maybe noted below:")
      email.should have_css(".additional_notes", :text => "Additional Notes: **approved_transfer_history_text**")
      email.should have_content("Please consult directly with this shelter regarding all transfer requests that you have sent to them, their contact details are below:")

      email.should have_css("strong", :text => "Shelter Needs Help")
      email.should have_content("123 Main St Apt B")
      email.should have_content("Apt 101")
      email.should have_content("Redwood City, CA 94063")
      email.should have_content("Tel: 111-222-3333")
      email.should have_content("Email: needs_the_help@shelter.com")
      email.should have_link("needs_the_help@shelter.com", :href => "mailto:needs_the_help@shelter.com")

      email.should have_content("Once the animal has been transported to your shelter the record for Cutie will be transferred to your animal database within Shelter Exchange. If you are having difficultly locating the record please contact the Shelter Needs Help to ensure they have clicked the 'Complete' button on the Dashboard page, this will transfer the record to your shelter.")

      email.should have_selector(".closing") do |closing|
        closing.should have_content("Kind regards,")
        closing.should have_content("Shelter Exchange Team")
      end
    end
  end

  describe ".rejected" do

    before do
      @email = TransferMailer.rejected(@transfer, "**rejected_transfer_history_text**")
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["need_animal@help.com"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Transfer Request from Shelter Needs Help for Cutie - Rejected"
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

      email.should have_content("Unfortunately your request to transfer Cutie to your shelter or rescue has been declined by Shelter Needs Help and the reason is given below.")
      email.should have_css(".additional_notes", :text => "Additional Notes: **rejected_transfer_history_text**")
      email.should have_content("Please consult directly with this shelter regarding all transfer requests that you have sent to them, their contact details are below:")

      email.should have_css("strong", :text => "Shelter Needs Help")
      email.should have_content("123 Main St Apt B")
      email.should have_content("Apt 101")
      email.should have_content("Redwood City, CA 94063")
      email.should have_content("Tel: 111-222-3333")
      email.should have_content("Email: needs_the_help@shelter.com")
      email.should have_link("needs_the_help@shelter.com", :href => "mailto:needs_the_help@shelter.com")

      email.should have_selector(".closing") do |closing|
        closing.should have_content("Kind regards,")
        closing.should have_content("Shelter Exchange Team")
      end
    end
  end

  describe ".requestor_completed" do

    before do
      @email = TransferMailer.requestor_completed(@transfer, "**requestor_completed_transfer_history_text**")
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["need_animal@help.com"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Transfer Request for Cutie is Complete and ready to view"
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

      email.should have_content("Congratulations! The transfer request for Cutie has been completed by Shelter Needs Help and the animal record in Shelter Exchange has been transferred to your shelter. You can now edit and update this record.  Please view the 'Animals' section within Shelter Exchange or search by animal name to view this record.")
      email.should have_css(".additional_notes", :text => "Additional Notes: **requestor_completed_transfer_history_text**")

      email.should have_selector(".closing") do |closing|
        closing.should have_content("Kind regards,")
        closing.should have_content("Shelter Exchange Team")
      end
    end
  end

  describe ".requestee_completed" do

    before do
      @email = TransferMailer.requestee_completed(@transfer, "**requestee_completed_transfer_history_text**")
    end

    it "from the correct sender" do
      @email.from.should == ["do-not-reply@shelterexchange.org"]
    end

    it "sending to the correct recipient" do
      @email.to.should == ["needs_the_help@shelter.com"]
    end

    it "contains the correct subject" do
      @email.subject.should == "Transfer Request for Cutie is now Complete"
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

      email.should have_content("Thank you! You have completed the transfer for Cutie and the animal record in Shelter Exchange has now been moved to Shelter Wanna Help. You will no longer be able to edit this record however you can view the record on the Community page by searching by the shelter name.")
      email.should have_css(".additional_notes", :text => "Additional Notes: **requestee_completed_transfer_history_text**")

      email.should have_selector(".closing") do |closing|
        closing.should have_content("Kind regards,")
        closing.should have_content("Shelter Exchange Team")
      end
    end
  end
end

