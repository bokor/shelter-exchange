require "rails_helper"

describe TransferHistory do

  it "has a default scope" do
    expect(TransferHistory.scoped.to_sql).to eq(TransferHistory.order('transfer_histories.created_at DESC').to_sql)
  end
end

# Class Methods
#----------------------------------------------------------------------------
describe TransferHistory, ".create_with" do

  it "creates a status history" do
    expect(TransferHistory.count).to eq(0)

    transfer_history = TransferHistory.create_with(1, 2, "adopted", "testing")

    expect(TransferHistory.count).to eq(1)

    expect(transfer_history.shelter_id).to eq(1)
    expect(transfer_history.transfer_id).to eq(2)
    expect(transfer_history.status).to eq("adopted")
    expect(transfer_history.reason).to eq("testing")
  end
end

# Instance Methods
#----------------------------------------------------------------------------
describe TransferHistory, "#transfer" do

  it "belongs to a transfer" do
    transfer = Transfer.new
    transfer_history = TransferHistory.new :transfer => transfer

    expect(transfer_history.transfer).to eq(transfer)
  end

  it "returns a readonly transfer" do
    transfer_history = TransferHistory.gen
    expect(transfer_history.reload.transfer).to be_readonly
  end
end

describe TransferHistory, "#shelter" do

  it "belongs to a shelter" do
    shelter = Shelter.new
    transfer_history = TransferHistory.new :shelter => shelter

    expect(transfer_history.shelter).to eq(shelter)
  end

  it "returns a readonly shelter" do
    transfer_history = TransferHistory.gen
    expect(transfer_history.reload.shelter).to be_readonly
  end
end

