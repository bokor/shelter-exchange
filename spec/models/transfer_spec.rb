require "spec_helper"

describe Transfer do

  it "has a default scope" do
    Transfer.scoped.to_sql.should == Transfer.order('transfers.created_at DESC').to_sql
  end

  it "requires presence of requestor" do
    transfer = Transfer.new :requestor => nil
    transfer.should have(1).error_on(:requestor)
    transfer.errors[:requestor].should == ["cannot be blank"]
  end

  it "requires presence of phone" do
    transfer = Transfer.new :phone => nil
    transfer.should have(1).error_on(:phone)
    transfer.errors[:phone].should == ["cannot be blank"]
  end

  it "requires presence of email" do
    transfer = Transfer.new :email => nil
    transfer.should have(1).error_on(:email)
    transfer.errors[:email].should == ["cannot be blank"]
  end

  it "requires correctly formatted email" do
    transfer = Transfer.new :email => "puppy.com"
    transfer.should have(1).error_on(:email)
    transfer.errors[:email].should == ["format is incorrect"]
  end

  it "validates transfer history reason when required" do
    transfer = Transfer.new :status => "rejected"
    transfer.should have(1).error_on(:transfer_history_reason)
    transfer.errors[:transfer_history_reason].should == ["cannot be blank"]
  end

  context "After Save" do

    it "creates transfer history" do
      TransferHistory.count.should == 0

      transfer = Transfer.gen :status => "rejected", :transfer_history_reason => "testing"

      TransferHistory.count.should == 1
      transfer.transfer_history_reason.should == "testing"
    end

    it "transfers the animal record" do
      shelter           = Shelter.gen
      requestor_shelter = Shelter.gen
      animal            = Animal.gen :shelter => shelter

      transfer = Transfer.gen :animal_id => animal.id, :shelter => shelter, :requestor_shelter => requestor_shelter, :status => "completed"

      transfer.reload.animal.shelter.should == requestor_shelter
    end
  end
end

# Constants
#----------------------------------------------------------------------------
describe Transfer, "::APPROVED" do
  it "returns the correct value for the approved constant" do
    Transfer::APPROVED.should == "approved"
  end
end

describe Transfer, "::REJECTED" do
  it "returns the correct value for the rejected constant" do
    Transfer::REJECTED.should == "rejected"
  end
end

describe Transfer, "::COMPLETED" do
  it "returns the correct value for the completed constant" do
    Transfer::COMPLETED.should == "completed"
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe Transfer, ".approved" do

  it "returns all of the approved transfers" do
    transfer1 = Transfer.gen :status => "approved"
    transfer2 = Transfer.gen :status => ""

    transfers = Transfer.approved.all

    transfers.count.should == 1
    transfers.should       =~ [transfer1]
  end
end

describe Transfer, ".rejected" do

  it "returns all of the rejected transfers" do
    transfer1 = Transfer.gen :status => "rejected", :transfer_history_reason => "transfer reason"
    transfer2 = Transfer.gen :status => ""

    transfers = Transfer.rejected.all

    transfers.count.should == 1
    transfers.should       =~ [transfer1]
  end
end

describe Transfer, ".completed" do

  it "returns all of the completed transfers" do
    transfer1 = Transfer.gen :status => "completed"
    transfer2 = Transfer.gen :status => ""

    transfers = Transfer.completed.all

    transfers.count.should == 1
    transfers.should       =~ [transfer1]
  end
end

describe Transfer, ".active" do

  it "returns all of the active transfers" do
    transfer1 = Transfer.gen :status => "approved"
    transfer2 = Transfer.gen :status => "approved"
    transfer3 = Transfer.gen :status => "completed"
    transfer4 = Transfer.gen :status => nil

    transfers = Transfer.active.all

    transfers.count.should == 3
    transfers.should       =~ [transfer1, transfer2, transfer4]
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe Transfer, "#shelter" do

  it "belongs to a shelter" do
    shelter  = Shelter.new
    transfer = Transfer.new :shelter => shelter

    transfer.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    transfer = Transfer.gen
    transfer.reload.shelter.should be_readonly
  end
end

describe Transfer, "#requestor_shelter" do

  it "belongs to a requestor shelter" do
    shelter  = Shelter.new
    transfer = Transfer.new :requestor_shelter => shelter

    transfer.requestor_shelter.should == shelter
    transfer.requestor_shelter.class.should == Shelter
  end

  it "returns a readonly requestor shelter" do
    transfer = Transfer.gen
    transfer.reload.requestor_shelter.should be_readonly
  end
end

describe Transfer, "#animal" do

  it "belongs to an animal" do
    animal   = Animal.new
    transfer = Transfer.new :animal => animal

    transfer.animal.should == animal
  end
end

describe Transfer, "#transfer_histories" do

  before do
    @transfer          = Transfer.gen
    @transfer_history1 = TransferHistory.gen :transfer => @transfer
    @transfer_history2 = TransferHistory.gen :transfer => @transfer
  end

  it "returns a list of transfer histories" do
    @transfer.transfer_histories.count.should == 2
    @transfer.transfer_histories.should       =~ [@transfer_history1, @transfer_history2]
  end

  it "destroys the transfer histories when a transfer is deleted" do
    @transfer.transfer_histories.count.should == 2
    @transfer.destroy
    @transfer.transfer_histories.count.should == 0
  end
end

describe Transfer, "#new_request?" do

  it "returns true if new request" do
    transfer1 = Transfer.gen :status => ""
    transfer2 = Transfer.gen :status => "completed"

    transfer1.new_request?.should == true
    transfer2.new_request?.should == false
  end
end

describe Transfer, "#approved?" do

  it "returns true if approved" do
    transfer1 = Transfer.gen :status => "approved"
    transfer2 = Transfer.gen :status => "completed"

    transfer1.approved?.should == true
    transfer2.approved?.should == false
  end
end

describe Transfer, "#rejected?" do

  it "returns true if rejected" do
    transfer1 = Transfer.gen :status => "rejected"
    transfer2 = Transfer.gen :status => "completed"

    transfer1.rejected?.should == true
    transfer2.rejected?.should == false
  end
end

describe Transfer, "#completed?" do

  it "returns true if completed" do
    transfer1 = Transfer.gen :status => "completed"
    transfer2 = Transfer.gen :status => "approved"

    transfer1.completed?.should == true
    transfer2.completed?.should == false
  end
end

