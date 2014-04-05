require "spec_helper"

describe Transfer do

  it "has a default scope" do
    expect(Transfer.scoped.to_sql).to eq(Transfer.order('transfers.created_at DESC').to_sql)
  end

  it "requires presence of requestor" do
    transfer = Transfer.new :requestor => nil
    expect(transfer).to have(1).error_on(:requestor)
    expect(transfer.errors[:requestor]).to match_array(["cannot be blank"])
  end

  it "requires presence of phone" do
    transfer = Transfer.new :phone => nil
    expect(transfer).to have(1).error_on(:phone)
    expect(transfer.errors[:phone]).to match_array(["cannot be blank"])
  end

  it "requires presence of email" do
    transfer = Transfer.new :email => nil
    expect(transfer).to have(1).error_on(:email)
    expect(transfer.errors[:email]).to match_array(["cannot be blank"])
  end

  it "requires correctly formatted email" do
    transfer = Transfer.new :email => "puppy.com"
    expect(transfer).to have(1).error_on(:email)
    expect(transfer.errors[:email]).to match_array(["format is incorrect"])
  end

  it "validates transfer history reason when required" do
    transfer = Transfer.new :status => "rejected"
    expect(transfer).to have(1).error_on(:transfer_history_reason)
    expect(transfer.errors[:transfer_history_reason]).to match_array(["cannot be blank"])
  end

  context "After Create" do

    describe "#send_notification_of_transfer_request" do
      it "sends a notification for a new request" do
        TransferMailer.stub(:delay => TransferMailer)

        shelter = Shelter.gen
        transfer = Transfer.build :shelter => shelter, :transfer_history_reason => "transfer history reason"

        expect(TransferMailer).to receive(:requestor_new_request).with(transfer)
        expect(TransferMailer).to receive(:requestee_new_request).with(transfer, "transfer history reason")

        transfer.save!
      end
    end
  end

  context "After Save" do

    describe "#create_transfer_history!" do
      it "creates transfer history" do
        expect(TransferHistory.count).to eq(0)

        transfer = Transfer.gen :status => "rejected", :transfer_history_reason => "testing"

        expect(TransferHistory.count).to eq(1)
        expect(transfer.transfer_history_reason).to eq("testing")
      end
    end

    describe "#transfer_animal_record!" do
      it "transfers the animal record" do
        shelter = Shelter.gen
        requestor_shelter = Shelter.gen
        animal = Animal.gen :shelter => shelter

        transfer = Transfer.gen :animal_id => animal.id, :shelter => shelter, :requestor_shelter => requestor_shelter, :status => "completed"

        expect(transfer.reload.animal.shelter).to eq(requestor_shelter)
      end
    end

    describe "#send_notification_of_status_change" do

      it "sends notification when approved" do
        TransferMailer.stub(:delay => TransferMailer)

        shelter = Shelter.gen
        transfer = Transfer.gen :shelter => shelter

        expect(TransferMailer).to receive(:approved).with(transfer, "updated to approved")

        transfer.update_attributes({
          :status => "approved",
          :transfer_history_reason => "updated to approved"
        })
      end

      it "sends notification when rejected" do
        TransferMailer.stub(:delay => TransferMailer)

        shelter = Shelter.gen
        transfer = Transfer.gen :shelter => shelter

        expect(TransferMailer).to receive(:rejected).with(transfer, "updated to rejected")

        transfer.update_attributes({
          :status => "rejected",
          :transfer_history_reason => "updated to rejected"
        })
      end

      it "sends notification when completed" do
        TransferMailer.stub(:delay => TransferMailer)

        shelter = Shelter.gen
        transfer = Transfer.gen :shelter => shelter

        expect(TransferMailer).to receive(:requestor_completed).with(transfer, "updated to completed")
        expect(TransferMailer).to receive(:requestee_completed).with(transfer, "updated to completed")

        transfer.update_attributes({
          :status => "completed",
          :transfer_history_reason => "updated to completed"
        })
      end
    end

  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Transfer, ".approved" do

  it "returns all of the approved transfers" do
    transfer1 = Transfer.gen :status => "approved"
    Transfer.gen :status => ""

    transfers = Transfer.approved.all

    expect(transfers.count).to eq(1)
    expect(transfers).to match_array([transfer1])
  end
end

describe Transfer, ".rejected" do

  it "returns all of the rejected transfers" do
    transfer1 = Transfer.gen :status => "rejected", :transfer_history_reason => "transfer reason"
    Transfer.gen :status => ""

    transfers = Transfer.rejected.all

    expect(transfers.count).to eq(1)
    expect(transfers).to match_array([transfer1])
  end
end

describe Transfer, ".completed" do

  it "returns all of the completed transfers" do
    transfer1 = Transfer.gen :status => "completed"
    Transfer.gen :status => ""

    transfers = Transfer.completed.all

    expect(transfers.count).to eq(1)
    expect(transfers).to match_array([transfer1])
  end
end

describe Transfer, ".active" do

  it "returns all of the active transfers" do
    transfer1 = Transfer.gen :status => "approved"
    transfer2 = Transfer.gen :status => "approved"
    transfer3 = Transfer.gen :status => nil
    Transfer.gen :status => "completed"

    transfers = Transfer.active.all

    expect(transfers.count).to eq(3)
    expect(transfers).to match_array([transfer1, transfer2, transfer3])
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Transfer, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    transfer = Transfer.new :shelter => shelter

    expect(transfer.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    transfer = Transfer.gen
    expect(transfer.reload.shelter).to be_readonly
  end
end

describe Transfer, "#requestor_shelter" do

  it "belongs to a requestor shelter" do
    shelter = Shelter.new
    transfer = Transfer.new :requestor_shelter => shelter

    expect(transfer.requestor_shelter).to eq(shelter)
    expect(transfer.requestor_shelter.class).to eq(Shelter)
  end

  it "returns a readonly requestor shelter" do
    transfer = Transfer.gen
    expect(transfer.reload.requestor_shelter).to be_readonly
  end
end

describe Transfer, "#animal" do

  it "belongs to an animal" do
    animal = Animal.new
    transfer = Transfer.new :animal => animal

    expect(transfer.animal).to eq(animal)
  end
end

describe Transfer, "#transfer_histories" do

  before do
    @transfer = Transfer.gen
    @transfer_history1 = TransferHistory.gen :transfer => @transfer
    @transfer_history2 = TransferHistory.gen :transfer => @transfer
  end

  it "returns a list of transfer histories" do
    expect(@transfer.transfer_histories.count).to eq(2)
    expect(@transfer.transfer_histories).to match_array([@transfer_history1, @transfer_history2])
  end

  it "destroys the transfer histories when a transfer is deleted" do
    expect(@transfer.transfer_histories.count).to eq(2)
    @transfer.destroy
    expect(@transfer.transfer_histories.count).to eq(0)
  end
end

describe Transfer, "#new_request?" do

  it "returns true if new request" do
    transfer1 = Transfer.gen :status => ""
    transfer2 = Transfer.gen :status => "completed"

    expect(transfer1.new_request?).to eq(true)
    expect(transfer2.new_request?).to eq(false)
  end
end

describe Transfer, "#approved?" do

  it "returns true if approved" do
    transfer1 = Transfer.gen :status => "approved"
    transfer2 = Transfer.gen :status => "completed"

    expect(transfer1.approved?).to eq(true)
    expect(transfer2.approved?).to eq(false)
  end
end

describe Transfer, "#rejected?" do

  it "returns true if rejected" do
    transfer1 = Transfer.gen :status => "rejected"
    transfer2 = Transfer.gen :status => "completed"

    expect(transfer1.rejected?).to eq(true)
    expect(transfer2.rejected?).to eq(false)
  end
end

describe Transfer, "#completed?" do

  it "returns true if completed" do
    transfer1 = Transfer.gen :status => "completed"
    transfer2 = Transfer.gen :status => "approved"

    expect(transfer1.completed?).to eq(true)
    expect(transfer2.completed?).to eq(false)
  end
end

