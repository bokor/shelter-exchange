require "spec_helper"

describe TransferHistory do

  it "has a default scope" do
    TransferHistory.scoped.to_sql.should == TransferHistory.order('transfer_histories.created_at DESC').to_sql
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe TransferHistory, "#transfer" do

  it "belongs to a transfer" do
    transfer         = Transfer.new
    transfer_history = TransferHistory.new :transfer => transfer

    transfer_history.transfer.should == transfer
  end

  it "returns a readonly transfer" do
    transfer_history = TransferHistory.gen
    transfer_history.reload.transfer.should be_readonly
  end
end

describe TransferHistory, "#shelter" do

  it "belongs to a shelter" do
    shelter          = Shelter.new
    transfer_history = TransferHistory.new :shelter => shelter

    transfer_history.shelter.should == shelter
  end

  it "returns a readonly shelter" do
    transfer_history = TransferHistory.gen
    transfer_history.reload.shelter.should be_readonly
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe TransferHistory, ".create_with" do

  it "creates a status history" do
    TransferHistory.count.should == 0

    transfer_history = TransferHistory.create_with(1, 2, "adopted", "testing")

    TransferHistory.count.should == 1

    transfer_history.shelter_id.should  == 1
    transfer_history.transfer_id.should == 2
    transfer_history.status.should      == "adopted"
    transfer_history.reason.should      == "testing"
  end
end

